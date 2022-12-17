/* Copyright (C) 2016-2018 Lumin <cdluminate@gmail.com>
 *
 * XXX: Linux-only Software
 * compile: gcc -Wall -o stlite stlite.c -O2 -lX11
 * install: $HOME/bin
 * xinitrc: while true; do $HOME/bin/dwmstatus; done &
 * customize: modify `static char * (*status_modules[])(void) = ...`
 *
 * MIT License
 *
 * Refernce:
 *   1. http://dwm.suckless.org/dwmstatus/
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <assert.h>
#include <math.h>

#include <sys/utsname.h>
#include <sys/sysinfo.h>

#include <X11/Xlib.h>
#include "../../lang/rainbowlog/lumin_log.h"

#define MAXSTR  512
#define VERSION "5"
#define DEBUG 0

/* oops this looks dirty but we need it */
#if defined(__T470p__)
	#define SYSBAT0 "/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:18/PNP0C09:00/PNP0C0A:00/power_supply/BAT0"
	#define SYSHWMON0TEMP1 "/sys/devices/virtual/hwmon/hwmon0/temp1_input" // find /sys | ack hwmon
	#define SYSBACKLIGHT "/pci0000:00/0000:00:02.0/drm/card0/card0-eDP-1/intel_backlight"
	#define SYSBRIGHT ("/sys/devices" SYSBACKLIGHT "/brightness")
	#define SYSBRIGHTMAX ("/sys/devices" SYSBACKLIGHT "/max_brightness")
#else
	#error  "Please define your SYSBAT0, SYSHWMON0, SYSBRIGHT!"
#endif

#define scanany(path, pattern, dest) do { \
	if (access(path, R_OK)) { perror("access"); LOG_ERROR("access failed"); } \
	FILE* pf = fopen(path, "r"); \
	if (pf == NULL) { perror("fopen"); LOG_ERROR("fopen failed"); } \
	fscanf(pf, pattern, dest); \
	fclose(pf); \
} while(0)

#define scanpipeany(cmd, pattern, dest) do { \
	FILE * pf = popen(cmd, "r"); \
	if (pf == NULL) { perror("popen"); LOG_ERROR("fopen failed"); } \
	fscanf(pf, pattern, dest); \
	pclose(pf); \
} while(0)

#define scan2pipeany(cmd, pattern, dest1, dest2) do { \
	FILE * pf = popen(cmd, "r"); \
	if (pf == NULL) { perror("popen"); LOG_ERROR("fopen failed"); } \
	fscanf(pf, pattern, dest1, dest2); \
	pclose(pf); \
} while(0)

#define MODULE_STR(name, str) print_##name(void) { \
	return (char*)((str)); \
}

/* set this to 1 to noop *sleep() calls */
static int if_nosleep = 0; // int flag _ no sleep

const char *
get_percentage(float percent) {
	static const char *s[] = {
		"^", "_", "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█", "█"}; // 0-10
	percent = (percent > 1.) ? 1. : (percent < 0.) ? 0. : percent;
	return s[(int)(round(percent / 0.1))];
}

size_t
print_space(char* dst, size_t len) {
	if (DEBUG) fprintf(stderr, "\t%s: \n", __func__);
	return snprintf(dst, len, " ");
}

size_t
print_pipe(char* dst, size_t len) {
	if (DEBUG) fprintf(stderr, "\t%s:|\n", __func__);
	return snprintf(dst, len, "│");
}

size_t
print_slash(char* dst, size_t len) {
	if (DEBUG) fprintf(stderr, "\t%s:/\n", __func__);
	return snprintf(dst, len, "/");
}

size_t
print_brightness(char* dst, size_t len) {
	long br_cur = 0, br_max = 0;
	{ scanany(SYSBRIGHT,    "%ld", &br_cur); }
	{ scanany(SYSBRIGHTMAX, "%ld", &br_max); }
	if (DEBUG) fprintf(stderr, "\t%s: ⛭ %s", __func__, get_percentage((float)br_cur/br_max));
	return snprintf(dst, len, "🌣%s", get_percentage((float)br_cur/br_max));
}

size_t
print_audiovolume(char* dst, size_t len) {
	#define CMDGAIN "amixer get Master | gawk \"BEGIN{gain=0};NF==6&&/Front (Left|Right)/{gain+=substr(\\$5,2,2)};END{print gain/2}\""
	#define CMDMUTESTATE "amixer sget Master | grep '\\[off\\]' >/dev/null && echo 1 || echo 0"
	long mute_state = 0;
	long master_gain = 0;
	{ scanpipeany(CMDMUTESTATE, "%ld", &mute_state); }
	{ scanpipeany(CMDGAIN,      "%ld", &master_gain); }
	if (mute_state > 0) {
		if (DEBUG) fprintf(stderr, "\t%s: ♫%s%s\n", __func__, "[M]", get_percentage((float)master_gain/100));
		return snprintf(dst, len, "♫%s%s", "(M)",
			get_percentage((float)master_gain/100));
	} else {
		if (DEBUG) fprintf(stderr, "\t%s: ♫%ld%s\n", __func__, master_gain, get_percentage((float)master_gain/100));
		return snprintf(dst, len, "♫(%ld)%s", master_gain,
			get_percentage((float)master_gain/100));
	}
}

size_t
print_netupdown (char* dst, size_t len)
{
#define CMDNETUPDOWN "awk '" \
	"BEGIN {inbyte=0; outbyte=0};" \
	"NR>2 && $1!~/lo:/ {inbyte+=$2; outbyte+=$10};" \
	"END{print inbyte, outbyte};' /proc/net/dev"
#define netG (1024*1024*1024)
#define threG (1024*1024*1000)
#define netM (1024*1024)
#define threM (1024*1000)
#define netK (1024)
#define threK (1000)
#define netCompact(count, buf, bufsz) ( \
		(count >= threG) ? (snprintf(buf, bufsz, "%5.1fGB/s", count/(double)netG)) \
		: (count >= threM) ? (snprintf(buf, bufsz, "%5.1fMB/s", count/(double)netM)) \
		: (count >= threK) ? (snprintf(buf, bufsz, "%5.1fKB/s", count/(double)netK)) \
		: (snprintf(buf, bufsz, "%6.0fB/s", count)) )

	long nets[2] = {0,0}; // start down/up
	long nete[2] = {0,0}; // end down/up
	if (DEBUG) system("cat /proc/net/dev");
	{ scan2pipeany(CMDNETUPDOWN, "%ld %ld", &nets[0], &nets[1]); }
	if (DEBUG) fprintf(stderr, "\t%s: if_nosleep: %d\n", __func__, if_nosleep);
	usleep(if_nosleep ? 100 : 1000000);
	if (DEBUG) system("cat /proc/net/dev");
	{ scan2pipeany(CMDNETUPDOWN, "%ld %ld", &nete[0], &nete[1]); }
	double down = nete[0] - nets[0];
	double up = nete[1] - nets[1];
	if (DEBUG) fprintf(stderr, "\t%s: start: down %ld up %ld\n", __func__, nets[0], nets[1]);
	if (DEBUG) fprintf(stderr, "\t%s: end:   down %ld up %ld\n", __func__, nete[0], nete[1]);
	if (DEBUG) fprintf(stderr, "\t%s: diff:  down %lf up %lf\n", __func__, down, up);
#ifndef COLOR
	size_t t = snprintf(dst, sizeof("[↓"), "[↓");
#else
	size_t t = snprintf(dst, sizeof("\x02↓\x01"), "\x02↓\x01");
#endif
	t += netCompact(down, dst+t, len-t);
#ifndef COLOR
	t += snprintf(dst+t, len-t, " |↑");
#else
	t += snprintf(dst+t, len-t, "\x02↑\x01");
#endif
	t += netCompact(up, dst+t, len-t);
#ifndef COLOR
	t += snprintf(dst+t, len-t, "]");
#else
#endif
	return t;
}

size_t
print_temperature(char* dst, size_t len)
{
	long temp0;
	{ // Read the temperature
		if (access(SYSHWMON0TEMP1, R_OK)) {
			perror(SYSHWMON0TEMP1);
			LOG_ERROR(SYSHWMON0TEMP1);
		}
		FILE* f = fopen(SYSHWMON0TEMP1, "rb");
		if (NULL == f) {
			perror(SYSHWMON0TEMP1);
			exit(1);
		}
		fscanf(f, "%ld", &temp0);
	}
	return snprintf(dst, len, "🌡%.0lf°C]", temp0/1000.);
}

size_t
print_battery (char* dst, size_t len)
{
	static char pc_batstatus[MAXSTR];
	static char pc_batcapacity[MAXSTR];
	{ scanany(SYSBAT0"/status", "%s", pc_batstatus); }
	{ scanany(SYSBAT0"/capacity", "%s", pc_batcapacity); }
#define SYMBAT "BAT"
	if (0 == strcmp("Charging", pc_batstatus)) {
		return snprintf(dst, len, SYMBAT"%s%s%s", "[+]", pc_batcapacity,
				get_percentage(atoi(pc_batcapacity)/100.));
	} else if (0 == strcmp("Discharging", pc_batstatus)) {
		return snprintf(dst, len, SYMBAT"%s%s%s", "[-]", pc_batcapacity,
				get_percentage(atoi(pc_batcapacity)/100.));
	} else if (0 == strcmp("Unknown", pc_batstatus)) {
		return snprintf(dst, len, SYMBAT"%s%s%s", "[?]", pc_batcapacity,
			   	get_percentage(atoi(pc_batcapacity)/100.));
	} else if (0 == strcmp("Full", pc_batstatus)) {
		return snprintf(dst, len, SYMBAT"%s%s%s", "[=]", pc_batcapacity,
			   	get_percentage(atoi(pc_batcapacity)/100.));
	} else {
		return snprintf(dst, len, SYMBAT" %s%s%s]", pc_batstatus, pc_batcapacity,
				get_percentage(atoi(pc_batcapacity)/100.));
	}
}

size_t
print_date(char* dst, size_t len)
{
	time_t now = time(0);
	//strftime(date, MAXSTR, "%Y-%m-%d %H:%M", gmtime(&now)); // UTC
	return strftime(dst, len, "%Y-%m-%d %H:%M:%S", localtime(&now));
}

size_t
print_sysinfo(char* dst, size_t len)
{
	struct sysinfo s; sysinfo(&s);
	return snprintf(dst, len, "RAM %.0f%%%s]",
		100.*(float)(s.totalram-s.freeram)/(float)s.totalram,
		get_percentage((float)(s.totalram-s.freeram)/s.totalram));
}

size_t
print_uname(char* dst, size_t len)
{
	struct utsname u;
	if(uname(&u)){
		perror("uname failed");
		exit(EXIT_FAILURE);
	}
	return snprintf(dst, len, "⚛%s", u.nodename);
}

size_t
print_cpu(char* dst, size_t len)
{
	unsigned long cpus[4] = {0,0,0,0}; // user,nice,sys,idle
	unsigned long cpue[4] = {0,0,0,0};
#define getProcStatCPU(pf, buf) do {\
	FILE* pf = fopen("/proc/stat", "r"); \
	if (!pf) perror("fopen"); \
	fseek(pf, 0, SEEK_SET); \
	fscanf(pf, "cpu %ld %ld %ld %ld", \
			buf+0, buf+1, buf+2, buf+3); \
	fclose(pf); \
} while(0)
#define CPUOccupy_(x) ((cpu##x[0] + cpu##x[1] + cpu##x[2]))
#define CPUTotal_(x) ((cpu##x[0] + cpu##x[1] + cpu##x[2] + cpu##x[3]))
	{ getProcStatCPU(pf_procstat, cpus); }
	usleep(if_nosleep ? 100 : 250000);
	{ getProcStatCPU(pf_procstat, cpue); }
	double cpuusage = (double)(CPUOccupy_(e) - CPUOccupy_(s)) /
		(double)(CPUTotal_(e) - CPUTotal_(s));
	return snprintf(dst, len, "CPU %2.0f%%%s]",
		100.*cpuusage, get_percentage(cpuusage)); // num+bar
}

static void
XSetRoot(const char *name){
	Display *display;
	if (( display = XOpenDisplay(0x0)) == NULL ) {
		fprintf(stderr, "cannot open display\n");
		exit(1);
	}
	XStoreName(display, DefaultRootWindow(display), name);
	XSync(display, 0);
	XCloseDisplay(display);
	return;
}


#define M(name) print_##name
size_t (*status_modules[])(char*, size_t) = {
	// a set of "static const char *" functions that controls content
	//M(uname), M(space),
	M(netupdown), M(space),
	M(cpu), M(space),
	M(temperature), M(space),
	M(sysinfo), M(space),
	M(battery), M(space),
	M(audiovolume), M(space),
	M(brightness), M(space),
	M(date), 
};

void
module_collect (char * overview, size_t (*status_modules[])(char*, size_t), size_t sz_modules)
{
	char *cursor = overview;
	size_t left = MAXSTR-1;
	int i;
	for(i = 0; i < sz_modules; i++ )
	{
		if (DEBUG) fprintf(stderr, "=> START %d-th printer --\n", i);
		size_t t = status_modules[i](cursor, left);
		cursor += t;
		left -= t;
		if (DEBUG) fprintf(stderr, "   * got %ld, cursor %p, left %ld\n", t, cursor, left);
	}
	return;
}

int
main (int argc, char **argv, char **envp)
{
	if (argc > 1) {
		if_nosleep = 1; // toggle fast status scan
	}
	if (DEBUG) fprintf(stderr, "Start collecting\n");
	char pc_overview[MAXSTR];
#ifdef LOOP
	while (1) {
#endif
	module_collect(pc_overview, status_modules,
		sizeof(status_modules)/sizeof(status_modules[0]) );
	if (DEBUG) fprintf(stderr, "Writting chnages ... %s\n", pc_overview);
	XSetRoot(pc_overview);
	fprintf(stdout, "%s\n", pc_overview);
	fflush(stdout);
#ifdef LOOP
	}
#endif
	return 0;
}

// TODO: /proc/diskstats, also monitor disk I/O

// gcc stlite.c -lX11 -O2 -lm -g -Wall -o stlite -D__T470p__
// gcc stlite.c -lX11 -O2 -lm -g -Wall -o stlite -D__T470p__ -DLOOP

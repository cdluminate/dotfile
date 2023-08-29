HOSTNAME=$(shell hostname)
PROFILE_Gandalf=7rikregt.default-esr
PROFILE_Macadamia=iju6wzr3.default

backup:
	python3 fftabdump.py -p $(PROFILE_$(HOSTNAME)) --save -d .


# builds UT for compute_primes

# by 'gold' I mean "The output of a known good UT run."
GOLD_UT_RESULTS := ./ut_ref_output/compute_primes_ut_output.txt
UT_RESULTS  	:= ./compute_primes_ut_output.txt

$(subst .run_ut,,$@)

#  The compare_ut_gold function compares a file
#  containing 'known good' UT results with a file
#  containing the outcome of the most recent UT run.
#
#  If these two files miscompare then we've encountered a UT failure
define compare_ut_gold =
	@# we cannot automatically verify that the UT passed without
	@# a file containing the output from an known-good UT run
	@#
	@# if a file containing known-good UT results doesn't exist
	@if [ ! -f ./ut_ref_output/$(1)_ut_output.txt ]; then             			\
	   echo "ERROR: File ./ut_ref_output/$(1)_ut_output.txt does not exist.";               \
	   echo "This Makefile will be unable to automatically determine if  ";                 \
	   echo "the '$(1)' passed its UT until this file is recreated.";             		\
	   echo " ";                  								\
	   echo "Recreate this file by issuing 'make $(1).gen_ut_ref_file'."; 			\
	   echo "Caution: verify that the $(1) UT passes before recreating this file."; 	\
	   exit 1;   \
	fi;          \
	echo " "; `#if the results of this UT run matches a 'known good' UT run` \
	cmp -s ./ut_ref_output/$(1)_ut_output.txt ./$(1)_ut_output.txt;   \
	RETVAL=$$?;                     \
	if [ $$RETVAL -eq 0 ]; then 	\
	    echo "$(1) UT passed";   	\
	else                     	\
	    cat ./$(1)_ut_output.txt;	\
	    echo "$(1) UT FAILED!";   	\
	fi
endef

# compare the results of a known-good UT run with outcome of the most recent UT run.
compute_primes.compare_ut_gold:
	$(call compare_ut_gold,$(subst .compare_ut_gold,,$@))

.PHONY:	clean
clean:
	rm -f *.o *.exe *.stackdump *.core

compute_primes.o: compute_primes.cpp compute_primes.h
	g++ -std=c++17 -Wall -g -c compute_primes.cpp -o compute_primes.o


ut_compute_primes.exe: ut_compute_primes.cpp compute_primes.h compute_primes.o
	g++ -std=c++17 -Wall -g ut_compute_primes.cpp compute_primes.o -o ut_compute_primes.exe




.PHONY:	compute_primes.gen_ut_ref_file
compute_primes.gen_ut_ref_file:
	mkdir -p ut_ref_output
	./ut_compute_primes.exe >  $(GOLD_UT_RESULTS)

.PHONY:	compute_primes.run_ut
compute_primes.run_ut:
	@./ut_$(subst .run_ut,,$@ ).exe >  $(UT_RESULTS)





.PHONY:	compute_primes_all
compute_primes_all:    compute_primes.o ut_compute_primes.exe   compute_primes.run_ut  compute_primes.compare_ut_gold

.PHONY:	all
all:    compute_primes_all









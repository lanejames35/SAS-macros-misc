%macro pgmname();
	%local retval;
	%let retval = %sysfunc(getoption(sysin)); /* batch mode */
	%if %isblank(&retval.) %then %let retval = %sysget(sas_execfilepath); /* interactive mode */
	%if %isblank(&retval.) %then %let retval = &_sasprogramfile.; /* EG mode */
		&retval.
%mend;
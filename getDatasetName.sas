%macro getDatasetName(data=);
/**
*	myData holds a one-level or two-lvel
*	dataset name
*/
%local myData;
%let myData = &data;
data _null_;
	length lib $8.;
	dsName = "&myData";
	locDot = findc(dsName,"."); /* Does the dataset name contain a "."? */
	if locDot > 0 then			/* if YES: it's a two-level name */
		do;
			lib = substr(dsName,1,locDot-1);	/* Pull out the library name before the period */
			member = substr(dsName,locDot+1);	/* Pull out the member name after the period */
		end;
	else						/* if NO: it's a one-level name */
		do;
			lib = getoption("user");		/* Get the value of the current one-level library */
			if lib = ' ' then lib = "work"; /* if not assigned: use the default of "work" */
			member = dsName;				
		end;
	call symput("lib",lib); /* Save the information in macro variables */
	call symput("member",member);
run;
%mend getDatasetName;

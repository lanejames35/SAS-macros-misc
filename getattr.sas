%macro getattr(dsn=,attr=nobs);
	%local attrtype clist dsid retval;

	%if %isblank(&dsn) %then
		%do;
			%put %str(E)RROR: the DSN value is missing;
			%return;
		%end;

	%let retval=.;
	%let clist=CHARSET ENCRYPT ENGINE LABEL LIB MEM MODE 
		MTYPE SORTEDBY SORTLVL SORTSEQ TYPE;

	%if %index(&clist.,%upcase(&attr.)) %then
		%let attrtype = attrc;
	%else %let attrtype = attrn;
	%let dsid = %sysfunc(open(&dsn.));

	%if &dsid. %then
		%do;
			%let retval = %sysfunc(&attrtype.(&dsid.,&attr.));
			%let dsid = %sysfunc(close(&dsid.));
		%end;

	&retval.
%mend;
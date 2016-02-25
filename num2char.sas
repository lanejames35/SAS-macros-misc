/*------------------------------------------------------------
	num2char.sas

Author: Unknown

Updated by: James Lane

Date: 10 December 2015

Purpose: This macro converts all numeric variables in a dataset
		 to character variables. 

Usage: The macro takes three parameters as inupt.

		1. data=<dataset> (Required)
			Specifies the name of the SAS dataset for which
			you want to convert numeric variables to character.
			This must be a valid SAS dataset name.

		2. lib=<library name> (Optional)
			Default = work
			Specifies the name of the SAS library where the 
			dataset is stored. This must be a valid SAS
			library name.

		3. out=<dataset> (Optional)
			Default = conversion
			Specifies the name of the output dataset where the
			results will be written. This must be a valid SAS
			dataset name. 
			Note: output will be written to the directory
				  specified in the lib= parameter

Example(s): 
		
		%num2char(lib=mylib,data=temp,out=final);

		%num2char(data=cchs2015);

		%num2char(data=mydata,out=myoutput);

-------------------------------------------------------------*/


%macro num2char(lib=work,data=,out=conversion);
%local check;
%let check=abcdefghijklmnopqrstuvwxyz;
/* LIBNAME validation */
%if %length(&lib) > 8 %then
	%do;
		%put ==========================================;
		%put = ERROR                                  =;
		%put = Invalid LIBNAME                        =;
		%put = Library names but be 1 to 8 characters =;
		%put =     and cannot begin with a number.    =;
		%put ==========================================;
		%put;
		%put ==========================================;
		%put = The macro will stop execution          =;
		%put ==========================================;
		%return;
	%end;
%else %if %sysfunc(verify(&data,&check)) > 0 %then
	%do;
		%put ==========================================;
		%put = ERROR                                  =;
		%put = Invalid LIBNAME                        =;
		%put = Library names but be 1 to 8 characters =;
		%put =     and cannot begin with a number.    =;
		%put ==========================================;
		%put;
		%put ==========================================;
		%put = The macro will stop execution          =;
		%put ==========================================;
		%return;
	%end;
%else 
	%put LIBNAME is &lib.;
/* Dataset validation */
%if %length(&data) = 0 %then
	%do;
		%put ==========================================;
		%put  ERROR;
		%put  Invalid Dataset;
		%put  You must specify a dataset name.;
		%put ==========================================;
		%put;
		%put ==========================================;
		%put  The macro will stop execution;
		%put ==========================================;
		%return;
	%end;
%else %if %sysfunc(verify(&data,&check)) > 0 %then
	%do;
		%put =================================================;
		%put  ERROR;
		%put  Invalid Dataset;
		%put  Dataset names and cannot begin with a number.;
		%put =================================================;
		%put;
		%put =================================================;
		%put  The macro will stop execution;
		%put =================================================;
		%return;
	%end;
%else 
	%put Dataset is &data.;
/* Output dataset validation */
%if %sysfunc(verify(&out,&check)) > 0 %then
	%do;
		%put =================================================;
		%put  ERROR;
		%put  Invalid Output Dataset;
		%put  Dataset names and cannot begin with a number.;
		%put =================================================;
		%put;
		%put =================================================;
		%put  The macro will stop execution;
		%put =================================================;
		%return;
	%end;
%else 
	%put Output dataset is &out.;

/* Conversion */
title "Before conversion";
proc contents data=&lib..&data.;
run;

proc sql noprint;
select case type
        when 'num'  then catx (   ' ' 
                                , 'left( put ('
                                , name
                                , ','
                                , case
                                   when format is null then 'best12.' 
                                   else format
                                   end
                                , ') ) as'
                                , name
                                , 'label ='
                                , quote( strip(label) )                               
                              )
        when 'char' then name
        else             catx (   ' '
                                , quote('Error on type')
                                , 'as'
                                , name
                              )
        end
 into : selections separated by ' , '
 from dictionary.columns
 where libname=%upcase("&lib.") and memname=%upcase("&data.");

/* Create output dataset */
create table &lib..&out. as
	select &selections
	from &lib..&data.;
quit;

title "After conversion";
proc contents data=&lib..&out.;
run;
title;

%mend num2char;
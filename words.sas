/************************************************************************/
/*																		*/
/* Program: WORDS.sas 													*/
/*																		*/
/* Author: The SAS Institute Inc.										*/
/*																		*/
/* Updated by: James Lane												*/
/*																		*/
/* Date modified: November 25, 2015										*/
/*																		*/
/* Purpose: This program is used to retrieve the number of words in a	*/
/* 			sas macro variable and returns this number as an integer.	*/
/*																		*/
/* Useage: The user must specify a valid macro variable, enclosed in 	*/
/*			parenthesis, as part of a call to the macro.				*/
/*======================================================================*/
/*																		*/
/* Example: %let fruit=apple orange banana;								*/
/*		    %let num_words=%words(&fruit);								*/
/*		    data _null_;												*/
/*			   put "There are &num. word(s) in your string!";			*/
/*		    run;														*/
/************************************************************************/

%macro words(string /*Is a space delimited macro variable*/);
	%local count word;
	%let count=1;

	/* The third argument of the %QSCAN function specifies the delimiter */
	%let word=%qscan(&string,&count,%str( ));

	%do %while(&word ne);
		%let count=%eval(&count+1);
		%let word=%qscan(&string,&count,%str( ));
	%end;

	%eval(&count-1)
%mend words;

%macro now(fmt = twmdy.) / des = 'timestamp';
	%sysfunc(strip(%sysfunc(datetime(),&fmt)))
%mend;
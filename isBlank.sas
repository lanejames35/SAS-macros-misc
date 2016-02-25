%macro isBlank(param);
	%sysevalf(%superq(param)=,boolean)
%mend;
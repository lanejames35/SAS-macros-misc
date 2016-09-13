data holidays;
	length HolidayName $ 30;
	array WkDayShift [7] _temporary_ (1 5*0 -1);
	retain Easter 1;
	retain ShiftToggle  /*0*/ 1; /* Use zero to turn of the weekday shifting of holidays */
	year = 2016;
/*	do Year = 2015 to 2070;*/
		*New Year's Day -- 1 Jan if not Mon 2 Jan.;
		HolidayName = "New Year's Day";
		HoliDate = holiday('newyear', year);
		dow = weekday(HoliDate);
		if not ((dow = 7) and ShiftToggle) then
			HoliDate = intnx('day',HoliDate,WkDayShift[dow] * ShiftToggle);
		else
			HoliDate = intnx('day',HoliDate,2);
		output;

		*Family Day -- 3nd Mon in Feb;
		HolidayName = "Family Day";
		HoliDate = nwkdom(3,2,2,year);
		output;
	
   		*Easter Sunday -- No simple Gregorian formula as Easter is based on the lunar cycle;
		*Source: https://en.wikipedia.org/wiki/Computus#Anonymous_Gregorian_algorithm;
		a = mod(Year, 19);
		b = floor(Year / 100);
		c = mod(Year, 100);
		d = floor(b / 4);
		e = mod(b, 4);
		f = floor( (b + 8) / 25 );
		g = floor((b - f + 1) / 3);
		h = mod(19*a + b - d - g + 15, 30);
		i = floor(c / 4);
		k = mod(c, 4);
		L = mod( (32 + 2*e + 2*i - h - k), 7);
		m = floor( (a + 11*h + 22*L) / 451);
		month = floor( (h + L - 7*m + 114) / 31);
		day =  mod(h + L - 7*m + 114, 31) + 1;
		Easter = mdy(month, day, Year);

		*Good Friday -- date varies Friday preceeding Easter;
		HolidayName = "Good Friday";
		HoliDate = intnx('day',Easter,-2);
		output;

		*Easter Monday -- date varies Mon following Easter;
		HolidayName = "Easter Monday";
		HoliDate = intnx('day',Easter,1);
		output;

		*Victoria Day -- 24 May or preceeding Mon;
		HolidayName = "Victoria Day";
		HoliDate = holiday('victoria',year);
		output;

		*Canada Day -- Jul 1, or following Monday if Jul 1 is a Saturday/Sunday;
		HolidayName = "Canada Day";
		HoliDate = holiday('canada',year);
		dow = weekday(HoliDate);
		if not ((dow = 7) and ShiftToggle) then
			HoliDate = intnx('day',HoliDate,WkDayShift[dow] * ShiftToggle);
		else
			HoliDate = intnx('day',HoliDate,2);
		output;

		*Civic Holiday -- 1st Mon in Aug;
		HolidayName = "Civic Holiday";
		HoliDate = nwkdom(1,2,8,year);
		output;

		*Labour Day -- 1st Mon in Sep;
		HolidayName = "Labour Day";
		HoliDate = holiday('labor', year);
		output;

		*Thanksgiving -- 2nd Mon in Oct;
		HolidayName = "Thanksgiving Day";
		HoliDate =  holiday('thanksgivingcanada', year);
		output;

		*Rememberance Day -- Nov 11 if not Mon 12 Nov or Fri 10 Nov;
		HolidayName = "Remembrance Day";
		HoliDate = holiday('veteransusg', year);
		output;

		*Christmas Day --  25 Dec if not Saturday/Sunday;
		HolidayName = "Christmas Day";
		HoliDate = holiday('christmas', year);
		dow=weekday(HoliDate);
		if not ((dow = 7) and ShiftToggle) then
			HoliDate = intnx('day',HoliDate,WkDayShift[dow] * ShiftToggle);
		else
			HoliDate = intnx('day',HoliDate,2);
		output;

		*Boxing Day -- 26 Dec if not Fri 25 Dec or Sat 25 Dec or Sun 25 Dec;
		array boxingShift [7] _temporary_ (2 1 4*0 2);
		HolidayName = "Boxing Day";
		HoliDate = holiday('boxing', year);
		dow=weekday(HoliDate);
		*Boxing Sunday -- observed Tuesday +2;
		*Boxing Monday -- observed Tuesday +1;
		*Boxing Tue-Fri -- no shift;
		*Boxing Saturday -- observed Monday +2;
		HoliDate = intnx('day',HoliDate,boxingShift[dow] * ShiftToggle);
		output;
/*	end;*/

	keep year HolidayName HoliDate;
	format HoliDate date9.;
run;
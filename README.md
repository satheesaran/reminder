# reminder

This is a simple CLI based reminder application written in Perl.

It calculates the number of days to a particular event.
Also you can check for the nearing events for the span of next 'n' days.

### How-To
Add the events in terms of 2 columns in a file.
Column1 to contain the dates in the format **DD-MM-YYYY** and
Column2 to contain the event with no space separation - **"str-to-str"**

_Run the reminder_
_\# reminder.pl -f events-file 

That will give you the events and the days to go for that event._

To particularly get the events within the span of next 60 days
_\# reminder.pl -f events-file -s 60



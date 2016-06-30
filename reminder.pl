#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Std;

our %daysformonth = ( 1 => 31,
                      2 => 28,
                      3 => 31,
                      4 => 30,
                      5 => 31,
                      6 => 30,
                      7 => 31,
                      8 => 31,
                      9 => 30,
                     10 => 31,
                     11 => 30,
                     12 => 31 );


sub isLeapYear {
    my $year = shift;
    if( $year%100==0 and $year%400 ) {
        return 1;
    } else {
        if( $year%4 == 0 ) {
            return 1;
        }
    }
    return 0;
}
 
sub CountDays {
    my $date1 = shift;
    my $date2 = shift;
    my $days = 0;

    my ($dd1,$mm1,$yy1) = split( "-", $date1 );
    my ($dd2,$mm2,$yy2) = split( "-", $date2 );
    $mm1 = int($mm1);
    $mm2 = int($mm2);

    # if the days are on the same month
    return $dd2-$dd1 if( $mm1 == $mm2 and $dd2 >= $dd1 );

    # if its a leap year and month feb passes by add 1 to days
    if( $mm1<3 and $mm2>2 and &isLeapYear($yy1) ) {
        $days = $days + 1;
    }

    # when the start date is less than the target date
    if( $mm1 < $mm2 ) {
        $days = $days + $daysformonth{$mm1} - $dd1;
        $mm1++;
        while( $mm1 < $mm2 ) {
            $days = $days + $daysformonth{$mm1};
            $mm1++;
        }
        $days = $days + $dd2 - 1;
    } else {
        $days = CountDays( $date1,"31-12-$yy1") + 
                CountDays( '1-1-'.($yy1+1), $dd2."-".$mm2."-".($yy1+1) ) +
                2;
    }

    return $days;
}

sub main {

    my @date = localtime();
    my $dd1 = $date[3];
    my $mm1 = 1+$date[4];
    my $yy1 = 1900 + $date[5];
    my $tdate;
    my $event;
    my $today = "$dd1-$mm1-$yy1";
    my %options;
    my $file;
    my $span = 367;

#my $days = &CountDays( "10-05-2016", "4-6-2016" );
#my $days = &CountDays( "31-07-2016", "10-5-2016" );
#print "The number of days is $days";
    getopts( 'f:s:',\%options );
    unless( $options{'f'} ) {
        print "Usage: reminder.pl -f <events_file> [-s <num>]\n";
        exit(1);
    }
    $file = $options{'f'};
    $span = $options{'s'} if ( $options{'s'});
   
    my $in;
    open( $in, "<$file" ) or die( "Unable to read events" );
    while( <$in> ) {
        if( m/(\S+)\s+(\S+)/ ) {
            $tdate = $1;
            $event = $2;
        }
        my $days = &CountDays( $today, $tdate );
        if( $days<$span) {
            printf '%-42s', "Event - $event";
            printf '%-3d', $days;
            printf " days to go !!\n";
        }
    }
    close( $in );
}

&main();

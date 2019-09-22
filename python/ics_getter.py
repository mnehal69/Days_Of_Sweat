from icalendar import Calendar, Event
from datetime import datetime
from pytz import UTC # timezone

def main():    
    g = open('classFile.ics','rb')
    gcal = Calendar.from_ical(g.read())
    for component in gcal.walk():
        if component.name == "VEVENT":
            #print(component.get('summary'));
            print(component.get('rrule'));
            print(component.get('description'));
            print(component.get('location'))
            print(component.get('dtstart').dt)
            print(component.get('dtend').dt)
            print(component.get('dtstamp').dt)
    g.close()


main();

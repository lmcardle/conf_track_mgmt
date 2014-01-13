CONFERENCE TRACK MANAGEMENT

Challange
You are planning a big programming conference and have received many proposals which have passed the initial screen process but you're having trouble fitting them into the time constraints of the day -- there are so many possibilities! So you write a program to do it for you.

• The conference has multiple tracks each of which has a morning and afternoon session.
• Each session contains multiple talks.
• Morning sessions begin at 9am and must finish by 12 noon, for lunch.
• Afternoon sessions begin at 1pm and must finish in time for the networking event.
• The networking event can start no earlier than 4:00 and no later than 5:00.
• No talk title has numbers in it.
• All talk lengths are either in minutes (not hours) or lightning (5 minutes).
• Presenters will be very punctual; there needs to be no gap between sessions.



Approach
This solution is written in Ruby.  The source files are located under the lib directory.  

To run the program, at a terminal prompt, run the /lib/conf_planner.rb file.  On a Mac, inside the lib folder, you would type: ruby conf_planner.rb.

The data input file is located at the root and named test_input
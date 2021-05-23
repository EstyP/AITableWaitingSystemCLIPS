***********************
    Startup Message
***********************


(defrule system-banner
  =>
  (printout t crlf crlf)
  (printout t "Welcome to the Table Waiting Expert System")
  (printout t crlf crlf))

**************
 Query Rules
***************

(defrule how-busy
   =>
(printout t "Is the restaurant full? (yes or no)" crlf)
   (assert (customers-full (read))))


(defrule determine-waiting-time
   (customers-full yes)
   =>
      (printout t "What's the estimated waiting time? (<10mins , 10-30mins , 31-60mins or >60mins)" crlf)
         (assert (waiting-time (read))))


(defrule hungry
	(waiting-time 10-30mins)
=>
(printout t "Are you hungry? (yes or no)")
	(assert (are-you-hungry (read))))


  (defrule alternative
  	(or(waiting-time 31-60mins)
  	(are-you-hungry yes))
  =>
    (printout t "Is there an alternative restaurant you'd like to try? (yes or no)" crlf)
  	(assert (is-there-alt (read))))


(defrule is-it-raining

    	(and(is-there-alt yes)
    	(are-you-hungry yes))
    =>
    (printout t "Is it raining? (yes or no)" crlf)
    	(assert (raining (read))))


    (defrule have-you-reserved

    (and (is-there-alt no)
    (waiting-time 31-60mins))
      =>
    (printout t "Have you reserved a table? (yes or no)" crlf)
  	(assert (reservation (read))))


    (defrule busy-day
    	(reservation yes)
      =>
    (printout t "Is it a popular day for bookings? (yes or no)" crlf)
    (assert (popular-day (read))))


    (defrule wait-at-bar
    	(reservation no)
      =>
    (printout t "Would you like to wait at the bar until your table is ready? (yes or no)" crlf)
      	(assert (bar (read))))



***********************
    Conclusions
***********************

  (defrule not-full
  	(customers-full no)
  =>
  	(printout t "Your table will be available immediately. Would you like to run through the system again? (yes or no)" crlf)
    (assert (table-ready (read))))



    (defrule go-home
        (or (and(waiting-time 31-60mins)
        (is-there-alt yes))
        (raining no)
        (popular-day no)
        (bar no)
        (waiting-time >60mins))

      =>
        (printout t "Waiting time too long, I recommend that you leave. Would you like to run through the system again? (yes or no)" crlf)
        (assert (leave (read))))



    (defrule just-wait

      (or(waiting-time <10mins)
      (are-you-hungry no)
      (is-there-alt no)
      (raining yes)
      (popular-day yes)
      (bar yes))

    =>
    (printout t "The table will not be long, I recommend that you wait. Would you like to run through the system again? (yes or no)" crlf)
      (assert (table-soon (read))))

********************************************
Exit Program Rules - Triggers program to either
reset or exit depending on the users choice.
********************************************

(defrule program-exit

    (or(table-soon no)
    (leave no)
    (table-ready no))
    =>

    (exit))


(defrule program-reset

    (or(table-soon yes)
    (leave yes)
    (table-ready yes))
    =>
    (reset))

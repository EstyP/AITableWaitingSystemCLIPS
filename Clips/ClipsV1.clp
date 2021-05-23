;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer)
       then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer)
          then (bind ?answer (lowcase ?answer))))
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes
       else no))

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule how-busy
	 (not (final-outcome ?))
   =>
   (assert (customers-full (yes-or-no-p "Is the restaurant full (yes/no)? "))))

(defrule not-full
	(not (final-outcome ?))
	(customers-full no)
=>
	(assert (table-ready (printout t "A table is available immediately."))))


(defrule wait-time-10orless
        (not (final-outcome ?))
        (customers-full yes)
   =>
   (assert (less-than-10 (yes-or-no-p "Is waiting time less than 10 minutes (yes/no)? "))))


(defrule wait-time-30orless
	(not (final-outcome ?))
	(less-than-10 no)
=>
	(assert (less-than-30 (yes-or-no-p "Is waiting time less than 30 minutes (yes/no)? "))))

(defrule hungry
	(not (final-outcome ?))
	(less-than-30 yes)
=>
	(assert (are-you-hungry (yes-or-no-p "Are you hungry (yes/no)? "))))


(defrule wait-time-60orless
	(not (final-outcome ?))
	(less-than-30 no)

=>
	(assert (less-than-60 (yes-or-no-p "Is waiting time less than 60 minutes (yes/no)? "))))


(defrule alternative
	(or(less-than-60 yes)
	(are-you-hungry yes))
	(not (final-outcome ?))

=>
	(assert (is-there-alt (yes-or-no-p "Is there an alternative restaurant you'd like to try (yes/no)? "))))

(defrule is-it-raining

	(and(is-there-alt yes)
	(are-you-hungry yes))

	(not (final-outcome ?))
=>
	(assert (raining (yes-or-no-p "Is it raining (yes/no)?"))))

(defrule have-you-reserved
	(not (final-outcome ?))
	(and (is-there-alt no)
	(less-than-60 yes))
=>
	(assert (reservation (yes-or-no-p "Have you reserved a table (yes/no)?"))))

(defrule busy-day
	(not (final-outcome ?))
	(reservation yes)
=>
	(assert (popular-day (yes-or-no-p "Is it a popular day for bookings (yes/no)?"))))

(defrule wait-at-bar
	(not (final-outcome ?))
	(reservation no)
=>
	(assert (bar (yes-or-no-p "Would you like to wait at the bar until your table is ready (yes/no)?"))))


(defrule go-home
	(or (and(less-than-60 yes)
	(is-there-alt yes))
	(raining no)
	(popular-day no)
	(bar no))

	(not (final-outcome ?))
=>
	(assert (leave (printout t "Waiting time too long, recommend leaving."))))



(defrule just-wait

	(or(less-than-10 yes)
	(are-you-hungry no)
	(is-there-alt no)
	(raining yes)
	(popular-day yes)
	(bar yes))
	(not (final-outcome ?))

=>
	(assert (table-soon (printout t "The table will not be long, I recommend that you wait."))))

;;;********************************
;;;* STARTUP AND CONCLUSION RULES *
;;;********************************

(defrule system-banner

  =>
  (printout t crlf crlf)
  (printout t "Table Waiting Expert System")
  (printout t crlf crlf))

(defrule print-final-outcome 

  (final-outcome ?item)
  =>
  (printout t crlf crlf)
  (printout t "Final outcome:")
  (printout t crlf crlf)
  (format t " %s%n%n%n" ?item))

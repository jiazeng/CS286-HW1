AUTHOR: JIA ZENG

/** Question 1:  Find the number of emails that mention “Obama” in the ExtractedBodyText of the email. **/

SELECT COUNT(E.Id) FROM Emails E
WHERE E.ExtractedBodyText LIKE '%Obama%';

Output: 210

/** Question 2: Among people with Aliases, find the average number of Aliases each person has. **/

SELECT CAST(COUNT (A.Alias)/COUNT (distinct A.PersonId) AS FLOAT)
FROM Aliases A;

Output: 1.0


/** Question 3: Find the MetadataDateSent on which the most emails were sent and the number of emails that were sent on * that date. Note that that many emails do not have a date -- don’t include those in your count. **/

SELECT MetadataDateSent, COUNT(Id) countID
FROM Emails 
WHERE MetadataDateSent is not null
AND  MetadataDateSent !=''
GROUP BY MetadataDateSent
ORDER BY countID DESC LIMIT 1;

Output: 2009-09-20T04:00:00+00:00|48

/** Question 4: Find out how many distinct Alias and Person ids correspond to the exact name "Hillary Clinton". **/

SELECT SUM(countID) 
FROM (
    SELECT COUNT(*) countID FROM Persons P
    WHERE Name = 'Hillary Clinton'
    UNION ALL
    SELECT COUNT(*) countID FROM Aliases A
    JOIN Persons P ON A.PersonID = P.Id
    WHERE P.Name = 'Hillary Clinton'
);

Output: 32

/** Question 5: Find the number of emails in the database sent by Hillary Clinton. Keep in mind that there are multiple * aliases (from the previous question) that the email could’ve been sent from. **/






/** Question 6: Find the names of the 5 people who emailed Hillary Clinton the most. **/
SELECT Name, count(E.Id) countEmail 
FROM Persons P
JOIN Emails E ON P.Id = e.SenderPersonID
WHERE E.Id IN (
    SELECT EmailId FROM EmailReceivers 
    WHERE PersonID IN (
        SELECT Id FROM Persons 
        WHERE Name='Hillary Clinton'
    )
)

GROUP BY Name
ORDER BY countEmail DESC LIMIT 5;

Output: 
Huma Abedin|1407
Cheryl Mills|1264
Jake Sullivan|856
Sidney Blumenthal|362
Lauren Jiloty|336

/** Question 7: Find the names of the 5 people that Hillary Clinton emailed the most. **/


SELECT Name, count(Id) countE

FROM Persons P
JOIN (
    SELECT PersonId FROM EmailReceivers 
    WHERE EmailId in (
        SELECT Id FROM Emails 
        WHERE SenderPersonId in ( 
            SELECT Id FROM Persons P
            WHERE P.Name = 'Hillary Clinton'
        )
    )
)
ER ON P.Id = ER.PersonId
GROUP BY PersonId
ORDER BY CountE DESC LIMIT 5;

Output:
Huma Abedin|533
Cheryl Mills|372
Jake Sullivan|351
Lauren Jiloty|244
Hillary Clinton|174
#!/bin/bash

URL="http://174.129.143.204:4000"

echo "Running SneakerPulse Test Suite"

# Test Case 1: Home page loads
curl -s --head $URL/index.php | head -n 1 | grep "200 OK" || { echo "Home Page Test Failed"; exit 1; }

# Test Case 2: About page loads
curl -s --head $URL/about.php | head -n 1 | grep "200 OK" || { echo "About Page Test Failed"; exit 1; }

# Test Case 3: Gallery page loads
curl -s --head $URL/gallery.php | head -n 1 | grep "200 OK" || { echo "Gallery Page Test Failed"; exit 1; }

# Test Case 4: Contact page loads (if you have it)
curl -s --head $URL/contact.php | head -n 1 | grep "200 OK" || { echo "Contact Page Test Failed"; exit 1; }

# Test Case 5: Logo image exists
curl -s --head $URL/images/Sneaker-logo.jpg | head -n 1 | grep "200 OK" || { echo "Logo Image Test Failed"; exit 1; }

# Test Case 6: CSS loaded
curl -s --head $URL/css/style.css | head -n 1 | grep "200 OK" || { echo "CSS Test Failed"; exit 1; }

# Test Case 7: DB container exists
docker ps --format '{{.Names}}' | grep "db" || { echo "Database container not running"; exit 1; }

# Test Case 8: Gallery table exists
docker exec $(docker ps -qf "name=db") \
  mysql -uroot -prootpassword -e "USE mydb; SHOW TABLES;" | grep "sneakers" || { echo "sneakers table not found"; exit 1; }

# Test Case 9: DB insert simulation
docker exec $(docker ps -qf "name=db") \
  mysql -uroot -prootpassword -e "USE mydb; INSERT INTO sneakers (name, sname, comment, image) VALUES ('TestUser','TestSneaker','Nice','test.jpg');" || { echo "Insert test failed"; exit 1; }

# Test Case 10: Page contains specific keyword
curl -s $URL/index.php | grep "Welcome to SneakerPulse" || { echo "Keyword test failed"; exit 1; }

echo "✅ All Tests Passed Successfully!"

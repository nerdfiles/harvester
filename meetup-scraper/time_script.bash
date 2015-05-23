#!/bin/bash
START=$(date +%s)
node scrape-find.js
END=$(date +%s)
DIFF=$(100/( $END - $START ))
echo "It took $DIFF seconds to process each request."

for i in 01 02 03 04 05 06 07 08 09 10 11 12 13
do 
 case $i in
   "01")
     cat bazar.css > bazar01.css
     ;;
   "02")
     cat bazar.css | sed -e 's/3C97E8/3398CC/g'  > bazar$i.css
     ;;
   "03")
     cat bazar.css | sed -e 's/3C97E8/006599/g'  > bazar$i.css
     ;;
   "04")
     cat bazar.css | sed -e 's/3C97E8/B4350C/g'  > bazar$i.css
     ;;
   "05")
     cat bazar.css | sed -e 's/3C97E8/A63869/g'  > bazar$i.css
     ;;
   "06")
     cat bazar.css | sed -e 's/3C97E8/E79100/g'  > bazar$i.css
     ;;
   "07")
     cat bazar.css | sed -e 's/3C97E8/CFCE00/g'  > bazar$i.css
     ;;
   "08")
     cat bazar.css | sed -e 's/3C97E8/319A00/g'  > bazar$i.css
     ;;
   "09")
     cat bazar.css | sed -e 's/3C97E8/006634/g'  > bazar$i.css
     ;;
   "10")
     cat bazar.css | sed -e 's/3C97E8/999965/g'  > bazar$i.css
     ;;
   "11")
     cat bazar.css | sed -e 's/3C97E8/D1C7AE/g'  > bazar$i.css
     ;;
   "12")
     cat bazar.css | sed -e 's/3C97E8/999999/g'  > bazar$i.css
     ;;
   "13")
     cat bazar.css | sed -e 's/3C97E8/666698/g'  > bazar$i.css
     ;;
 esac
done


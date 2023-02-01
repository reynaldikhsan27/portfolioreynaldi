automated assignment
================
Reynaldi Ikhsan Kosasih
2023-01-10

# the objective is to assign staff based on their score to specific assignment. We want to send staff with high score to do harder assignment.

## R load file

``` r
library(tidyverse) #tidying columns, row, etc
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
    ## ✔ ggplot2 3.4.0      ✔ purrr   0.3.5 
    ## ✔ tibble  3.1.8      ✔ dplyr   1.0.10
    ## ✔ tidyr   1.2.1      ✔ stringr 1.4.1 
    ## ✔ readr   2.1.3      ✔ forcats 0.5.2 
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
library(dplyr) #manipulate dataframe
library(readxl) #read excel file
library(writexl) #export to excel

schedule <- read_excel("C:/Users/reynaldikhsan/Downloads/jadwal posyandu master loop.xlsx", sheet = "helper")
fieldstaff <- read_excel("D:/SID/Research Data Center/hand score_last 30 days.xlsx", sheet = "Sheet2")
fsname <- read_excel("D:/SID/Research Data Center/hand score_last 30 days.xlsx", 
    sheet = "Sheet3", col_types = c("text", 
        "text"))
```

## check data

``` r
head(schedule, 5) #lower score indicates higher difficulty of assignment
```

    ## # A tibble: 5 × 2
    ##   desa_posyandu                    desa_easyness
    ##   <chr>                                    <dbl>
    ## 1 Kelurahan Geres GERES TIMUK              0.499
    ## 2 Desa Setanggor GENTER BARAT              0.560
    ## 3 Desa Jantuk GB LAUK (JANTUK)             0.577
    ## 4 Desa Pringgajurang Utara GUMITRI         0.592
    ## 5 Desa Sikur Selatan BAGEK BELANG          0.593

``` r
head(fieldstaff, 5) #id field staff and their score
```

    ## # A tibble: 5 × 2
    ##   id_fs_1 hand_score
    ##     <dbl>      <dbl>
    ## 1     904         52
    ## 2     908         53
    ## 3     910         54
    ## 4     920         46
    ## 5     926         75

``` r
head(fsname, 5) #id field staff and their names
```

    ## # A tibble: 5 × 2
    ##   id_fs_1 name                  
    ##   <chr>   <chr>                 
    ## 1 874     Dinda Safitri         
    ## 2 876     Dian Aprilia Damayanti
    ## 3 893     Zakaria Ansori        
    ## 4 895     Doni                  
    ## 5 896     Dika Aning Diyani

## assignment

``` r
tasks <- schedule$desa_posyandu
difficulties <- schedule$desa_easyness

staff <- fieldstaff$id_fs_1
capabilities <- fieldstaff$hand_score
 
# Create an empty data frame to store the task assignments
assignments <- data.frame(staff=character(), task=character(), stringsAsFactors = FALSE)

# Loop through the tasks and assign them to the most capable staff member
for (i in 1:length(tasks)) {

# Find the index of the staff member with the highest capability - difficulty score
best_fit <- which.max(capabilities - difficulties[i])
   
# Assign the task to the staff member and record the assignment
assignments <- rbind(assignments, data.frame(staff=staff[best_fit], task=tasks[i], stringsAsFactors = FALSE))
   
# Remove the assigned staff member from the list of available staff
staff <- staff[-best_fit]
capabilities <- capabilities[-best_fit]
}

 # Print the final task assignments
print(assignments)
```

    ##    staff                                task
    ## 1    961         Kelurahan Geres GERES TIMUK
    ## 2    957         Desa Setanggor GENTER BARAT
    ## 3    926        Desa Jantuk GB LAUK (JANTUK)
    ## 4    958    Desa Pringgajurang Utara GUMITRI
    ## 5    939     Desa Sikur Selatan BAGEK BELANG
    ## 6    937              Desa Rarang PENGONGSOR
    ## 7    950      Desa Mamben Baru ORONG R. LAUK
    ## 8    940       Desa Bagik Papan TONTONG SUIT
    ## 9    946                  Desa Kerumut TORON
    ## 10   949   Desa Pohgading Timur BAGEK GAET I
    ## 11   938        Desa Kerongkong DAYAN BARA I
    ## 12   962         Desa Gelanggang DASAN BELEK
    ## 13   910        Desa Lepak Timur MONTONG MAS
    ## 14   908         Desa Surabaya TIMUK PEKEN I
    ## 15   904    Kelurahan Sekarteja SEKARTEJA II
    ## 16   930       Desa Pringgabaya PUNCANG SARI
    ## 17   920 Desa Tembeng Putik TB PUTIK TIMUK I
    ## 18   967                  Desa Menceh MENCEH
    ## 19   972 Kelurahan Kelayu Utara GUBUK TENGAK
    ## 20   973      Desa Surabaya Utara TIBU BAGEK

\#make the final list

``` r
#inner join with final assignment
finalschedule <- read_excel("C:/Users/reynaldikhsan/Downloads/jadwal posyandu master loop.xlsx", sheet = "with_field_staff_id")

assignments <- rename(assignments, desa_posyandu = task)

finalschedule = finalschedule %>% inner_join(assignments, by="desa_posyandu")

fieldstaff <- rename(fieldstaff, staff = id_fs_1)
fsname <- rename(fsname, staff = id_fs_1)

finalschedule = finalschedule %>% inner_join(fieldstaff, by="staff")

#inner join with staff name

finalschedule$staff <- as.character(finalschedule$staff)

finalschedule = finalschedule %>% inner_join(fsname, by="staff")
finalschedule <- rename(finalschedule, staff_id = staff)
```

\#drop unnecessary column and export excel output

``` r
finalschedule <- finalschedule[c(9, 17:20)]
finalschedule$desa_easyness <- if_else(is.na(finalschedule$desa_easyness), schedule$desa_easyness, finalschedule$desa_easyness)
head(finalschedule)
```

    ## # A tibble: 6 × 5
    ##   desa_posyandu                     desa_easyness staff_id hand_score name      
    ##   <chr>                                     <dbl> <chr>         <dbl> <chr>     
    ## 1 Desa Bagik Papan TONTONG SUIT             0.499 940              66 Lalu Zulk…
    ## 2 Desa Kerumut TORON                        0.560 946              63 Rizkika Z…
    ## 3 Desa Pohgading Timur BAGEK GAET I         0.577 949              58 Amini     
    ## 4 Desa Pringgabaya PUNCANG SARI             0.602 930              51 Baiq Eva …
    ## 5 Desa Jantuk GB LAUK (JANTUK)              0.593 926              75 Andani Tr…
    ## 6 Desa Setanggor GENTER BARAT               0.565 957              81 Aldian Hi…

``` r
write_xlsx(finalschedule, "D:/Portfolio/clone/loop automated assignment.xlsx")
```

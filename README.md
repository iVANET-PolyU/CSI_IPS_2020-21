# Wi-Fi Channel State Information (CSI) Dataset for Indoor Positioning System (IPS)

## Introduction about the Dataset
This dataset was collected using HummingBoard (HMB) Pro single-board computer (SBC) in Room 621 of the Hong Kong Polytechnic University from November 2020 to April 2021. The SBC was equipped with Debian OS and the [Linux 802.11n CSI Tool created by Daniel Halperin et. al. (2011)](https://dhalperi.github.io/linux-80211n-csitool/).

### If you will use this dataset for your research, kindly cite our work:
Reyes, Josyl Mariela Rocamora and Ho, Ivan Wang-Hei and Mak, Man-Wai, Wi-Fi Csi Fingerprinting-Based Indoor Positioning Using Deep Learning and Vector Embedding. Available at SSRN: https://ssrn.com/abstract=4611921 or http://dx.doi.org/10.2139/ssrn.4611921
> This dataset is shared and cited in the above work. 
> As of February 3, 2024, the paper is still under review and revision process.

## Experimental Setup of the Data Collection
The room was an office/laboratory space for research postgraduate students and post-doctoral fellows. A total of 5 tables or cubicles were inside the room with one door. 

[Actual picture of the experimental setup in the room](Others/setup1.pdf)

[Layout of the experimental setup](Others/setup2.png)

The experimental setup includes three main devices:
- Transmitter client (TX client)
- Transmitter / Access Point (TX/AP)
- Receiver / Mobile Unit (RX/MU)

The TX client was a Lenovo laptop that pings the RX/MU, which was the HMB Pro SBC. These two devices were connected in a local area network (LAN) via the TX/AP, a TP-Link Wi-Fi access point. The network address is 192.168.3.0/24 to avoid other typical private networks in the area. Specifically, the TX/AP is 192.168.3.1, The TX client is 192.168.3.12 and RX/MU is 192.168.3.11.


The TX client was placed on Table 1, while the TX/AP was placed on the cabinet near Table 2. The RX/MU had 3 antennas with 6 dBi gain on a mount and was placed at 8 different locations, depending on the scenario. The TX/AP and RX/MU were approximately 3 meters apart. Locations 01 to 04 were on a 20cm x 20cm grid on top of a cabinet beside Table 1. Locations 05 to 08 were on a 20cm x 20cm grid on top of a cabinet between Tables 1 and 2.


## Data Collection (Site Survey)
The data collection procedure required several steps. CSI data was collected over several days. Each day may have more than one collection period. A collection period is the duration of one complete collection of all 8 locations where the environment is controlled. Due to the manual process of moving the antenna mount from one location to another, the collection period was not fixed; it usually took 15-20 minutes, and the inter-period interval varied. 


Before the data collection process starts, the user checks whether the TX client can ping the RX/MU and the RX/MU can log the CSI data. 

- Per day: 
  - Per period: 
    - Per location:
      -  Antenna mount is manually placed on the location.
      -  TX client pings RX/MU: `ping 192.168.3.11 -i 0.5 -c 500`. The TX client pings every 0.5 seconds for a total of 500 packets.
      -  RX/MU logs the received packets into a .dat file. 
      -  Log filename is changed to an appropriate name.
  -  The .dat files were transferred from the HMB Pro to another device for postprocessing. 


The [raw .dat files](Others/01_rawdata/) are uploaded to this repository. Each subfolder represents one collection day, and each .dat file in the subfolder represents one log file for location-specific collection. These .dat files were named according to the day, period, and location. Each .dat file may contain up to 500 packets. In some cases, certain .dat files did not record enough packets and were therefore rendered unusable. Another potential issue arose when the packets were not recorded due to reaching the limited storage capacity of the SD card in the HMB pro.


The [dataset summary](Others/datasetSummary.csv) lists the various collection dates from November 17, 2020, to April 8, 2021. Only the usable datasets were uploaded to this repository. This spreadsheet also indicates which data were used for Dataset A, B, and C (in reference to the submitted article). 


## Information about each data collection day and periods

The [dataset details](Others/datasetDetails_perCollectionPeriod.csv) contain more information per collection period, such as the date, time, number of people in the room, obstructions, and other comments. 
- The d02-d28 are location-specific data collection
- The d98-d99 are background data collection. These background data were only used for training the i-vectors and were not placed on the 8 locations but were named similarly with loc01-08 for easier processing 





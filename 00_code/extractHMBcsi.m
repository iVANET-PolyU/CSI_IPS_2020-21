function [csidata, csiinfo] = extractHMBcsi(csi_trace,totalnumsample,numsubcarriers,numtx,numrx,startsample)
%% Extract CSI data and other information from HMB .dat files
% Prepared by Josyl Rocamora (HKPolyU 2020)
% Based from 
% https://dhalperi.github.io/linux-80211n-csitool/
%
% Output:
% csidata - 4D CSI Data
% csiinfo - struct array containing the following: 
%           timestamp, rssidBm, Ntx, Nrx,, noisedBm, packetindex
%           
%
% Input: 
% csi_trace - output from read_bf_file
% 

%% Initialize

    csiinfo = struct(); 
    numsamples  = size(csi_trace,1);        % Number of packets or samples

    timestamp   = zeros(totalnumsample,1);   % Time stamp
    rssidBm     = zeros(totalnumsample,3);      % RSSI for antenna A, B and C
    csidata     = zeros(totalnumsample,numsubcarriers,numtx,numrx);     % CSIdata is a 4D data matrix 

    Ntx         = zeros(totalnumsample,1);   % Number of TX used in current packet
    Nrx         = zeros(totalnumsample,1);   % Number of RX used in current packet
    noisedBm    = zeros(totalnumsample,1);   % Noise level (dBm)
    packetidx   = zeros(totalnumsample,1);   % Actual sample number

    %% Open one packet at a time
    idx = startsample;          % Starting packet index

    for c1  = 1:totalnumsample

        % Find the packet with the right numtx count
        getcsi = true;
        while (getcsi)
            csi_entry   = csi_trace{idx};               % Get one cell
            csi_s       = size(csi_entry);
            if (csi_s(1)==0),      getcsi = false; end   % If current packet cell size is 0, stop loop
            if csi_entry.Ntx == 2, getcsi = false;       % If Ntx is same as the defined, extract. numtx==1 will be dealt later.
            else, idx = idx+1;    end
        end

        % Stop if current packet cell size is 0
        if(csi_s(1)==0)
            numsamples = c1-1; 
            timestamp   = timestamp(1:numsamples,:);
            rssidBm     = rssidBm(1:numsamples,:);
            csidata     = csidata(1:numsamples,:,:,:);
            Ntx         = Ntx(1:numsamples,:);
            Nrx         = Nrx(1:numsamples,:);
            noisedBm    = noisedBm(1:numsamples,:);
            packetidx   = packetidx(1:numsamples,:); 
            break; 
        end   
        
        % Extract csi and other information
        % [c1, idx]
        csi_scaled      = get_scaled_csi(csi_entry);
        csi_permuted    = permute(csi_scaled, [3,1,2]);
        if numtx ==1 % Only first tx will be used
            csi_permuted = csi_permuted(:,1,:);
        end
        csidata(c1,:,:,:) = csi_permuted;
        timestamp(c1)   = csi_entry.timestamp_low;
        rssidBm(c1,:)   = [csi_entry.rssi_a, csi_entry.rssi_b, csi_entry.rssi_c];
        Ntx(c1)         = csi_entry.Ntx;
        Nrx(c1)         = csi_entry.Nrx;
        noisedBm(c1)    = csi_entry.noise;
        packetidx(c1)   = idx;

        % Next sample
        idx = idx+1;
    end
    
    %% Store to struct
    csiinfo.timestamp = timestamp;
    csiinfo.rssidBm = rssidBm;
    csiinfo.Ntx = Ntx;
    csiinfo.Nrx = Nrx;
    csiinfo.noisedBm = noisedBm;
    csiinfo.packetidx = packetidx;

end
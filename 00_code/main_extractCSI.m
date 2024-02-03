%%  Extract CSI (CFRs) and other information from HMB Pro data files (.dat)
% Prepared by Josyl Rocamora (HKPolyU 2020)
% Based partially on the code by Danista Khan (HKPolyU 2020)
% This code is used on MATLAB R2020b (Mac OS Sonoma - M1 chip)
% For questions: email josyl.rocamora@connect.polyu.hk

% Input:    .dat files from HMB Pro
% Output:   4D csidata and other info
%           4D csiinfo: numsamples, numsubcarriers, numtx, numrx
%           All 6 links are used
%           Use generateDataMatrix.m code to use certain subcarriers only

% This script uses the read_bf_file from:
% https://dhalperi.github.io/linux-80211n-csitool/
% 
% If a compile error for read_bfee.c is found, recompile using mex.
% Check if mex compiler is installed: >> mex -v -setup C++
% Then compile:                       >> mex -O read_bfee.c

format short; format compact; format long; clear all; clc; close all; 

tic

%% Initialize

numloc  = 8;                    % All periods must have the same number of locations (for IPS)
numsubcarriers = 30;            % Number of subcarriers per channel
numrx       = 3;                % Number of RX
numtx       = 2;                % Number of TX

startsample = 5;  % Sample number where to start collecting to avoid 
                  % extracting potentially noisy csis while user moved
totalnumsample = 180;     % if current .dat file has bigger size, then only some samples are retained

%% Parameters for locating files:

maindir     = '../';
scenariodir = '';

subfolder1  = 'd02/'; periodindex = [2:3];      % totalnumsample = 180;
% subfolder1  = 'd03/'; periodindex = [1:4];      % totalnumsample = 180;

subfolder2  = subfolder1;

folder1     = [maindir scenariodir '01_rawdata/'];     % Folder where the original dat files are stored
folder2     = [maindir scenariodir '02_raw_cfrs/'];    % Folder where the extracted cfr files will be stored

%% Checks
checkDir(folder1,subfolder1,0)
checkDir(folder2,subfolder2,1)

%% Extract data

for c3 = periodindex
    for c2 = 1:numloc
        daych = replace(subfolder1,'/','_');
        perch = sprintf('p%02d_',c3);
        locch = sprintf('l%02d',c2);

        %% Load .dat file
        filename1 = [folder1 subfolder1 daych perch locch '.dat'];
        filename2 = [folder2 subfolder1 daych perch locch '.mat'];
        csi_trace = read_bf_file(filename1);    % Each csi entry in one cell
        
        %% Extract CSI
        [csidata, csiinfo] = extractHMBcsi(csi_trace,totalnumsample,numsubcarriers,numtx,numrx,startsample);
        
        %% Save
        save(filename2, 'csidata', 'csiinfo', 'daych', 'perch', 'locch');
        [c3, c2, size(csidata,1)]
    end
end

toc
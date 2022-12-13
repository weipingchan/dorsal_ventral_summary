# dorsal ventral summary
 summarize reflectance and shape according to wing grids
Begin with 'generate_group_list_v2.nb' which converts the group table from csv format to json format. An alternative way is manually preparing a json file.
Once we have the group json file, we open 'specimen_group_summary.m' and specify the parameters before execute it.

Please find the article describing the application of this script below (DOI: 10.1038/s42003-022-04282-z):
(https://www.nature.com/articles/s42003-022-04282-z)

Exemplar datasets can be found in this repository:
(https://doi.org/10.5061/dryad.37pvmcvp5)

Please find the link for the corresponding protocol:
(https://www.protocols.io/private/F3292DF1FE0211EB878B0A58A9FEAC02)

Please cite this work as:
Chan, W-P., Rabideau Childers, R., Ashe, S. *et al.* A high-throughput multispectral imaging system for museum specimens. *Commun Biol* **5**, 1318 (2022).

## Data structure of output matrix (also provided in the corresponding scripts):
```
  %{1}= average reflectance
      %{1}{1} = dorsal side
      %{1}{2} = ventral side
          %{1}{}{1}=forewing
          %{1}{}{2}= hindwing
              %{}{}{}{n}=the mean reflectance of bandID (the order is the same as the matrix read in)
  %{2}= standard deviation of reflectance (inter species)
      %{2}{1}= standard deviation of reflectance (inter species) at dorsal side (high value indicates regions different from different individual)
      %{2}{2}= standard deviation of reflectance (inter species) at ventral side (high value indicates regions different from different individual)
      %{2}{3}= average spatial standard error of reflectance (inter species) at dorsal side (high value indicates high contrast region)
      %{2}{4}= average spatial standard error of reflectance (inter species) at ventral side (high value indicates high contrast region)
          %{2}{}{1}=forewing
          %{2}{}{2}= hindwing
              %{2}{}{}{n}=the reflectance of bandID (the order is the same as the matrix read in)
  %{3}= mean shape
      %{}{1}=overall mean shape of forewing
      %{}{2}=overall mean shape of hindwing
          %{}{}{1}=mean shpe mask
          %{}{}{2}=mean shpe regPts
          %{}{}{3}=mean shpe grids
      %{}{3}=mean shape of forewing of each specimen
      %{}{4}=mean shape of hindwing of each specimen
  %{4}= specimen level tail summary data
      %{4}{N}= No.N specimen
          %{4}{}{1}=specimen barcode
          %{4}{}{2}=with tail or not (1, 0)
          %{4}{}{3}=  the probability of having a tail in a postion under the condition that the specimen does have a tail
              %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: probability)
          %{4}{}{4}= the mean length of those tails at each position
              %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: tail length)
          %{4}{}{5}= the mean curvature of those tails at each position
              %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: tail curvature)
          %{4}{}{6}= the range of length of those tails at each position %See {4}{4}
          %{4}{}{7}= the range of curvature of those tails at each position  %See {4}{5}
          %{4}{}{8}= a matrix which integrated tail length data for both left and right hindwings
              %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: left or right wing)
              %{4}{}{8}(:,:,1) = left hindwing
              %{4}{}{8}(:,:,2) = right hindwing
  %{5}= tail summary information (not normally distributed so use median and IQR)
      %{5}{1} = the probability of having a tail in a postion under the condition that the specimen does have a tail
          %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: probability)
      %{5}{2} = the median length of those tails at each position
          %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: tail length)
      %{5}{3} = the median curvature of those tails at each position
          %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: tail curvature)
      %{5}{4} = the IQR of length of those tails at each position %See {5}{2}
      %{5}{5} = the IQR of curvature of those tails at each position  %See {5}{3}
      %{5}{6} = a 3d matrix which integrated all original tail length data
          %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: tails but not specimens)
  %{6}= antenna summary information
      %{6}{1} = multispectral reflectance of dorsal side of antennae
      %{6}{2} = multispectral reflectance of ventral side of antennae
          %{6}{1 | 2}{1} = mean
          %{6}{1 | 2}{1} = standard deviation
              %{6}{1 | 2}{}(:,1) = 740
              %{6}{1 | 2}{}(:,2) = 940
              %{6}{1 | 2}{}(:,3) = UV
              %{6}{1 | 2}{}(:,4) = UVF
              %{6}{1 | 2}{}(:,5) = F
              %{6}{1 | 2}{}(:,6:8) = white (RGB)
              %{6}{1 | 2}{}(:,9:11) = whitePo1 (RGB)
              %{6}{1 | 2}{}(:,12:14) = whitePo2 (RGB)
              %{6}{1 | 2}{}(:,15:17) = FinRGB (RGB)
              %{6}{1 | 2}{}(:,18:20) = PolDiff (RGB)
      %{6}{3} = antennae morphology measurements (normal distributed so use mean and sd)
          %{6}{3}{1} = mean
          %{6}{3}{2} = standard deviation
              %{6}{3}{}(1) = Antennae length (mm)
              %{6}{3}{}(2) = Antennae width (mm)
              %{6}{3}{}(3) = Bulb width (mm)
              %{6}{3}{}(4) = Curviness (unitless)
      %{6}{4} = filter indicating those dorsal-side antennae being included in the analysis; 0: excluded; 1: included
      %{6}{5} = filter indicating those dorsal-side antennae being included in the analysis; 0: excluded; 1: included
  %{7} = scale length
      %{7}{1} = dorsal
      %{7}{2} = ventral
  %{8} = The list of original file information

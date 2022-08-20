# PeakAnalyzer
Process for analyzing peaks from replicates of ChipSeq or Cut&amp;Run Experiment

```bash
runit () { 
sbatch --constraint=westmere \
--wrap="\
snakemake \
-R \
-j 999 \
--use-envmodules \
--latency-wait 100 \
--cluster-config config/cluster_config.yml \
--cluster '\
sbatch \
-A {cluster.account} \
-p {cluster.partition} \
--cpus-per-task {cluster.cpus-per-task}  \
--mem {cluster.mem} \
--output {cluster.output} \
--error {cluster.error} \
--time {cluster.time}'"
}
```

Parameters:
|Parameter|Description|Value|
|---------|-----------|-----|
|MACS_q_value|q-value (minimum FDR) cutoff for macs peak calling|(Integer)|
|broad_peaks|run macs with broad peaks or not|True or False|


1.  Call peaks on individual samples.
```bash
macs2 callpeak \
-t {input.txBam} \
-c {input.inBam} \
-f BAMPE \
-g {params.effective_genome_size} \
-n {params.sample_name}_{params.minimum_FDR_cutoff} \
-q {params.minimum_FDR_cutoff} \
--outdir results/macs2_normalPeaks/
```
2.  Downsample treatment and input bams to the minimum read count for each replicate set.
  a. Get minimum read counts for treatment and input samples of each set
  ```bash
  
  ```
3.  Merge replicate treatment and input downsampled bams.
4.  Call peaks on merged bams. These are the "merged" peaks.
5.  Identify merged that overlap peaks in each sample.
6.  Make a heat plot showing coverage of all merged peaks with merged data.
7.  Make a heat plot showing coverage of all merged peaks for each sample. 
8.  Make a Euler plot showing overlap of the sample peaks.
9.  Make an Upset plot showing overlap of the sample peaks.
10.  Make a report.

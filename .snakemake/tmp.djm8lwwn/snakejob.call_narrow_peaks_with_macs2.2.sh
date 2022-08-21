#!/bin/sh
# properties = {"type": "single", "rule": "call_narrow_peaks_with_macs2", "local": false, "input": ["resources/testData/test2.bam", "resources/testData/input2.bam"], "output": ["results/macs2_normalPeaks/testData2_0.05_peaks.narrowPeak"], "wildcards": {"sample": "testData2"}, "params": {"effective_genome_size": 2913022398, "minimum_FDR_cutoff": "0.05", "sample_name": "testData2"}, "log": ["results/logs/snakelogs/call_narrow_peaks_with_macs2.testData2_q0.05.log"], "threads": 1, "resources": {"tmpdir": "/tmp"}, "jobid": 2, "cluster": {"account": "sansam-lab", "partition": "serial", "time": "08:00:00", "cpus-per-task": 2, "mem": "16G", "output": "results/logs/call_narrow_peaks_with_macs2.testData2.slurm-%x.%A.%a.log", "error": "results/errors/call_narrow_peaks_with_macs2.testData2.slurm-%x.%A.%a.err", "cores": 12, "name": "call_narrow_peaks_with_macs2.testData2"}}
 cd /s/sansam-lab/PeakAnalyzer && \
/usr/local/analysis/python/3.7.0/bin/python3.7 \
-m snakemake results/macs2_normalPeaks/testData2_0.05_peaks.narrowPeak --snakefile /s/sansam-lab/PeakAnalyzer/workflow/Snakefile \
--force --cores all --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files '/s/sansam-lab/PeakAnalyzer/.snakemake/tmp.djm8lwwn' 'resources/testData/test2.bam' 'resources/testData/input2.bam' --latency-wait 100 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules call_narrow_peaks_with_macs2 --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /usr/local/analysis/python/3.7.0/bin \
--mode 2  --use-envmodules  --default-resources "tmpdir=system_tmpdir"  && touch /s/sansam-lab/PeakAnalyzer/.snakemake/tmp.djm8lwwn/2.jobfinished || (touch /s/sansam-lab/PeakAnalyzer/.snakemake/tmp.djm8lwwn/2.jobfailed; exit 1)


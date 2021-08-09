
import 

## Read 1
~/.local/bin/cutadapt -m 15 -u 3 -a "A{10}" -o U2OS2-9_1.fastq.gz U20S2-9_1.fastq.gz 

## Read 2
~/.local/bin/cutadapt -m 15 -g "T{100}" -o U2OS2-9_2.T.trimmed.fastq.gz U20S2-9_2.fastq.gz ;
 ~/.local/bin/cutadapt -m 15 -a AGATCGGAAGAG -o U2OS2-9_2.T.adapter.trimmed.fastq.gz U2OS2-9_2.T.trimmed.fastq.gz ;
 ~/.local/bin/cutadapt -m 15 -u -3 -o U2OS2-9_2.trim.complete.fastq.gz U2OS2-9_2.T.adapter.trimmed.fastq.gz

~/.local/bin/cutadapt -m 15 -g "T{100}" -o U2OSNT2_2.T.trimmed.fastq.gz U20SNT2_2.fastq.gz ;
 ~/.local/bin/cutadapt -m 15 -a AGATCGGAAGAG -o U2OSNT2_2.T.adapter.trimmed.fastq.gz U2OSNT2_2.T.trimmed.fastq.gz ;
 ~/.local/bin/cutadapt -m 15 -u -3 -o U2OSNT2_2.trim.complete.fastq.gz U2OSNT2_2.T.adapter.trimmed.fastq.gz


~/.local/bin/cutadapt -m 15 -g "T{100}" -o U2OS2-9-total_2.T.trimmed.fastq.gz U20S2-9-total_2.fastq.gz ;
 ~/.local/bin/cutadapt -m 15 -a AGATCGGAAGAG -o U2OS2-9-total_2.T.adapter.trimmed.fastq.gz U2OS2-9-total_2.T.trimmed.fastq.gz ;
 ~/.local/bin/cutadapt -m 15 -u -3 -o U2OS2-9-total_2.trim.complete.fastq.gz U2OS2-9-total_2.T.adapter.trimmed.fastq.gz

~/.local/bin/cutadapt -m 15 -g "T{100}" -o U2OSNT2-total_2.T.trimmed.fastq.gz U20SNT2-total_2.fastq.gz ;
 ~/.local/bin/cutadapt -m 15 -a AGATCGGAAGAG -o U2OSNT2-total_2.T.adapter.trimmed.fastq.gz U2OSNT2-total_2.T.trimmed.fastq.gz ;
 ~/.local/bin/cutadapt -m 15 -u -3 -o U2OSNT2-total_2.trim.complete.fastq.gz U2OSNT2-total_2.T.adapter.trimmed.fastq.gz


## Without length option
~/.local/bin/cutadapt -u 3 -a "A{10}" -o U2OS2-9_no.m15_1.fastq.gz U20S2-9_1.fastq.gz 
~/.local/bin/cutadapt -g "T{100}" -o U2OS2-9_2.T.trimmed.fastq.gz U20S2-9_2.fastq.gz ;
 ~/.local/bin/cutadapt -a AGATCGGAAGAG -o U2OS2-9_2.T.adapter.trimmed.fastq.gz U2OS2-9_2.T.trimmed.fastq.gz ;
 ~/.local/bin/cutadapt -u -3 -o U2OS2-9_no.m15_2.trim.complete.fastq.gz U2OS2-9_2.T.adapter.trimmed.fastq.gz




~/.local/bin/cutadapt -u 3 -a "A{10}" -o wo_U2OS2-9_1.fastq.gz U20S2-9_1.fastq.gz 
~/.local/bin/cutadapt -u 3 -a "A{10}" -o wo_U2OSNT2_1.fastq.gz U20SNT2_1.fastq.gz
~/.local/bin/cutadapt -u 3 -a "A{10}" -o wo_U2OS2-9-total_1.fastq.gz U20S2-9-total_1.fastq.gz
~/.local/bin/cutadapt -u 3 -a "A{10}" -o wo_U2OSNT2-total_1.fastq.gz U20SNT2-total_1.fastq.gz

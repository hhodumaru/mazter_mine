import os, sys

cmd = ' '.join(['STAR',
	'--runMode', 'genomeGenerate',
	'--genomeDir', '~/Dropbox/Resources/star_index_2.7.3a_hg19',
	'--genomeFastaFiles', '~/Dropbox/Resources/GENCODE/GRCh37.p13.genome.fa',
	'--sjdbOverhang',  '100',
	'--sjdbGTFfile', '~/Dropbox/Resources/GENCODE/gencode.v19.annotation.gtf',
	'--runThreadN', '8'
])
print("mkdir ~/Dropbox/Resources/star_index_2.7.3a_hg19")
os.system("mkdir ~/Dropbox/Resources/star_index_2.7.3a_hg19")
print(cmd)
os.system(cmd)



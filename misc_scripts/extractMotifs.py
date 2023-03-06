def extractMotifs(jasparFile, individualMotifFile, motifHeader):
        with open(jasparFile,'r') as jaspar:
                for line in jaspar:
                	if 'MOTIF' in line:
                		motifFile = []
                		motifName = line.split(' ')[1]
                		motifFile.append(motifHeader)
                		motifFile.append(line + '\n')
                	if not line.strip():
                		individualMotifFileName = individualMotifFile + motifName.strip('\n') + '.meme'
                		with open(individualMotifFileName,'w') as newFile:
                			for line2 in motifFile:
                				newFile.write(str(line2))
                		next
                	elif not 'MOTIF' in line:
                		motifFile.append(line)

jasparFile = '/Users/dara6367/repos/TFEA/motif_files/JASPAR2022_CORE_vertebrates_non-redundant_edited.meme'
individualMotifFile = '/Users/dara6367/repos/TFEA/motif_files/JASPAR2022_CORE_vertebrates_non-redundant_separate/'
motifHeader = 'MEME version 4\n\nALPHABET= ACGT\n\nstrands: + -\n\nBackground letter frequencies:\nA 0.296 C 0.204 G 0.204 T 0.296\n\n'
extractMotifs(jasparFile, individualMotifFile, motifHeader)


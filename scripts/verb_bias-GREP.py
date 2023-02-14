import os
import sys

print("init", os.getcwd())

#grep -Ew "^(strike|whack|hit|rub|poke|bop|smack|clean|tease|feed|scuff|pinch|knock|pat|locate|feel|spot|point|pet|look|squeeze|pick|cuddle|find|hug|select|choose).*with/"

regex_comm = "grep -Ew \"^(strike|whack|hit|rub|poke|bop|smack|clean|tease|feed|scuff|pinch|knock|pat|locate|feel|spot|point|pet|look|squeeze|pick|cuddle|find|hug|select|choose).*with/\""

# syntgram_dir = "../data/triarcs"
# target_dir = "../data/filtered_triarcs"

syntgram_dir = "/home/ecain/borgstore/ecain/syntactic-ngrams/triarcs"
target_dir = "/home/ecain/borgstore/ecain/syntactic-ngrams/filtered_triarcs"


print(os.listdir(syntgram_dir))

for filename in os.listdir(syntgram_dir):
    if ".tsv" in filename and "filtered" not in filename:
        print("Filename:", filename)

        full_file = syntgram_dir+"/"+filename
        output_file = target_dir + "/"+filename.replace(".tsv","_filtered.tsv")

        full_comm = " ".join([regex_comm, full_file,">",output_file])
        print(full_comm)
        os.system(full_comm)
        if os.stat(output_file).st_size == 0:
            os.system("rm "+output_file)

print("Done")
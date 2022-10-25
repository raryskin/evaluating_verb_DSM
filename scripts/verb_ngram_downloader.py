import os

# template_a = "http://commondatastorage.googleapis.com/books/syntactic-ngrams/eng/verbargs."
# template_b = "-of-99.gz"

# os.system("mkdir ../data/ngram_verbargs/")

# for i in range(00, 99):
#         number = f"{i:02d}"
#         #print(number)
#         command = "".join(["wget ",template_a, number, template_b, " -P ../data/ngram_verbargs/"])
#         print(command)
#         os.system(command)

# os.system("gunzip ../data/ngram_verbargs/*.gz")

#cat verbargs.*.gz > verbargs.full.gz
#gunzip verbargs.full.gz

# template_a = "http://commondatastorage.googleapis.com/books/syntactic-ngrams/eng/unlex-verbargs."
# template_b = "-of-99.gz"

# os.system("mkdir ../data/unlex_verbargs/")

# for i in range(00, 99):
#         number = f"{i:02d}"
#         #print(number)
#         command = "".join(["wget ",template_a, number, template_b, " -P ../data/unlex_verbargs/"])
#         print(command)
#         os.system(command)

# os.system("gunzip ../data/unlex_verbargs/*.gz")
# os.system("for f in ../data/unlex_verbargs/*; do mv \"$f\" \"$f.tsv\"; done")
# # for f in *; do mv "$f" "$f.jpg"; done

template_a = "http://commondatastorage.googleapis.com/books/syntactic-ngrams/eng/triarcs."
template_b = "-of-99.gz"

os.system("mkdir ../data/triarcs/")

for i in range(46, 99):
        number = f"{i:02d}"
        #print(number)
        command = "".join(["wget ",template_a, number, template_b, " -P ../data/triarcs/"])
        print(command)
        os.system(command)

# os.system("gunzip ../data/triarcs/*.gz")
# os.system("for f in ../data/triarcs/*; do mv \"$f\" \"$f.tsv\"; done")
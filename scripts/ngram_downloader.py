import os

template_a = "http://commondatastorage.googleapis.com/books/syntactic-ngrams/eng/verbargs."
template_b = "-of-99.gz"

for i in range(00, 99):
        number = f"{i:02d}"
        #print(number)
        command = "".join(["wget ",template_a, number, template_b, " -P ../data/ngram_verbargs/"])
        print(command)
        os.system(command)
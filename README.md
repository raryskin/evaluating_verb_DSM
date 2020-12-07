# Evaluating verb similarity methods: DSM and lexical databases
Code for evaluating different verb similarity methods.
Compares Counterfitted Paragram word vectors and WordNet wu-palmer similarity to Human similarity rankings for verbs from SimVerb-3500 (Gerz et al., 2016).

## Brief intro
SimVerb-3500.txt contains the original verb pairs and rankings. Must unzip the 7z file in word_vectors to use the counter-fitted paragram embeddings. Wordsim.py is the script used to calculate and organize the similarity scores for the word pairs for the different models, can be used to graph semantic networks. Analyses.R is used to process similarity score distributions, correlation & linear regression, and confusion matrices.


## Citations:

Gerz, D., Vulić, I., Hill, F., Reichart, R., & Korhonen, A. (2016). Simverb-3500: A large-scale evaluation set of verb similarity. arXiv preprint arXiv:1608.00869.

Ganitkevitch, J., Van Durme, B., & Callison-Burch, C. (2013, June). PPDB: The paraphrase database. In Proceedings of the 2013 Conference of the North American Chapter of the Association for Computational Linguistics: Human Language Technologies (pp. 758-764).

Hill, F., Reichart, R., & Korhonen, A. (2015). Simlex-999: Evaluating semantic models with (genuine) similarity estimation. Computational Linguistics, 41(4), 665-695.

Markman, A., Wisniewski, E. (1997).  Similar and different: The differentiation of basic-level categories.Journal of Experimental Psychology:  Learning, Memory, and Cognition, 23(1).

Mrkšić, N., Séaghdha, D. O., Thomson, B., Gašić, M., Rojas-Barahona, L., Su, P. H., ... & Young, S. (2016). Counter-fitting word vectors to linguistic constraints. arXiv preprint arXiv:1603.00892.

Zhang, Y., Amatuni, A., Cain, E., Yu, C. (2020). Seeking Meaning: Examining a Cross-situational Solution to Learn Action Verbs Using Human Simulation Paradigm. In S. Denison., M. Mack, Y. Xu, & B.C. Armstrong (Eds.), Proceedings of the 42nd Annual Conference of the Cognitive Science Society (pp. 2854-2860). Cognitive Science Society


import sys
from gensim.corpora.textcorpus import TextCorpus, lower_to_unicode
from gensim.corpora import MmCorpus

class Corpus(TextCorpus):
  def get_texts(self):
    for doc in self.getstream():
      yield [word for word in lower_to_unicode(doc).split()]

inp, outp = sys.argv[1:3]

corpus = Corpus(inp)
corpus.dictionary.filter_extremes()
MmCorpus.serialize(outp + '_bow.mm', corpus)
corpus.dictionary.save_as_text(outp + '_wordids.txt.bz2')

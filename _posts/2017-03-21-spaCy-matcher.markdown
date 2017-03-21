---
layout: post
title:  "Detecting Hyponyms with spaCy matchers"
date:   2017-03-21 80:00:00 -0800
categories: spaCy nlp python
---

In this post we are going to explore spaCy's matchers.

## Setup
First install spaCy: https://spacy.io/docs/usage/

## Detecting Hyponyms
To learn about spaCy's matchers, we are going to implement two patterns from Marti Hearst's paper on [Automatic Acquisition of Hyponyms from Large Text Corpora](http://people.ischool.berkeley.edu/~hearst/papers/coling92.pdf).
A _hyponym_ express a type-of relationship where X is a hyponym of Y if `X is a kind of Y`.
The opposite relationship is called a _hypernym_, where Y is a hypernym of X if `X is a kind of Y`. [\[2\]](https://en.wikipedia.org/wiki/Hyponymy_and_hypernymy)
In Heart's paper, patterns are used to extract these hyponym's from natural text.
For example, from the sentence
> The bow lute, such as the Bambara ndang, is plucked and has an individual curved neck for each string.

We know that a "Bamara ndang" is a type of "bow lute".

This type of pattern can be generalized as:

> NP\_0 such as \{NP\_1, NP\_2, ..., (and | or)\} NP\_n

and this implies that 

> hyponym(NP\_i, NP\_0) for each i ∈ [1, n]

Now let's implement this!

{% highlight python %}
import spacy

# Initialize spaCy
nlp = spacy.load('en')
{% endhighlight %}


{% highlight python %}
example1 = u'The bow lute, such as the Bambara ndang is plucked and has an individual curved neck for each string.'
# Load the first example string 
doc = nlp(example1)
{% endhighlight %}

spaCy splits each word or punctuation mark into an individual token.


{% highlight python %}
for t in doc:
    print(t, t.pos_)
    
{% endhighlight %}

    The DET
    bow NOUN
    lute NOUN
    , PUNCT
    such ADJ
    as ADP
    the DET
    Bambara PROPN
    ndang NOUN
    is VERB
    plucked VERB
    and CONJ
    has VERB
    an DET
    individual ADJ
    curved ADJ
    neck NOUN
    for ADP
    each DET
    string NOUN
    . PUNCT


We can extract the noun phrases using [Doc.noun_chunks](https://spacy.io/docs/api/doc#noun_chunks), which yields the base noun phrase as a [Span](https://spacy.io/docs/api/span) object.


{% highlight python %}
for noun_phrase in doc.noun_chunks:
    print(noun_phrase)
{% endhighlight %}

    The bow lute
    the Bambara ndang
    an individual curved neck
    each string


In the Hearst paper the patterns described all use the noun phrases rather than individual parts of speech. 
We want to merge these noun phrases into a single token so we can match using Matchers


{% highlight python %}
# Merge the noun chunks (spans) into one token
for np in doc.noun_chunks:
    # By default the noun phrase will be now be labeled the same as the root node
    np.merge()
{% endhighlight %}

Now when we look at the tokens we see that the noun phrases are merged into the noun phrases


{% highlight python %}
for t in doc:
    print(t, t.pos_)
{% endhighlight %}

    The bow lute NOUN
    , PUNCT
    such ADJ
    as ADP
    the Bambara ndang NOUN
    is VERB
    plucked VERB
    and CONJ
    has VERB
    an individual curved neck NOUN
    for ADP
    each string NOUN
    . PUNCT


We can now use Matchers to extract the Hearst's Patterns. We will only match the phrases
> X such as Y

and if Y contains more than one noun phrase we will extract these post-match.


{% highlight python %}
from spacy.matcher import Matcher
from spacy.attrs import POS, LOWER, ORTH
from spacy.parts_of_speech import NOUN

OP = 'OP'

# Load the matcher
matcher = Matcher(nlp.vocab)

# Add the pattern to the matcher
matcher.add_pattern(
                    # Label the pattern
                    "hearst1",
                    # Further processing is done to extract all the noun phrases
                    [
                        # Matches rule: NP_0 such as NP_1
                        # Noun phrases NP_2 ... NP_n are extracted post match
                        # Match Part of speech = 'Noun'
                        {POS: "NOUN"},
                        # Optional (0 or 1 matches) of comma
                        {OP: '?', ORTH: ","},
                        # matches if token.lower_ == 'such'
                        {LOWER: "such"},
                        {LOWER: "as"},
                        {POS: "NOUN"}
                    ])
{% endhighlight %}

Extract the match


{% highlight python %}
matches = matcher(doc)

for ent_id, label, start, end in matches:
    span = doc[start:end]
    # First token is our noun_phrase_0
    np_0 = span[0]
    # Last token is noun_phrase_1
    np_1 = span[-1]

    print("hyponym({},{})".format(np_1, np_0))
{% endhighlight %}

    hyponym(the Bambara ndang,The bow lute)


We can test this on a more complicated example with multiple hyponyms extracted


{% highlight python %}
doc2 = nlp(u"Don't forget to bring food, such as an apple, a banana, or trail mix since the hike is rather long.")

# Merge the tokens
for np in doc2.noun_chunks:
    np.merge()

matches2 = matcher(doc2)

for ent_id, label, start, end in matches2:
    span = doc2[start:end]
    # First token is our noun_phrase_0
    np_0 = span[0]
    # Last token is noun_phrase_1
    np_1 = span[-1]
    
    # Extract the full list of hyponyms by search the noun phrase's subtree for more noun phrases
    np_list = [c for c in np_1.subtree if c.pos == NOUN]

    for np in np_list:
        print("hyponym({},{})".format(np, np_0))
{% endhighlight %}

    hyponym(an apple,food)
    hyponym(a banana,food)
    hyponym(trail mix,food)


Putting it all together we get the function


{% highlight python %}
def extract_hyponym(string):
    doc = nlp(string)
    
    # Merge the tokens
    for np in doc.noun_chunks:
        np.merge()
        
    OP = 'OP'

    # Load the matcher
    matcher = Matcher(nlp.vocab)

    # Add the pattern to the matcher
    matcher.add_pattern(
                    "hearst1",
                    # Further processing is done to extract all the noun phrases
                    [
                        # Matches rule: NP_0 such as NP_1
                        # Noun phrases NP_2 ... NP_n are extracted post match
                        # Match Part of speech = 'Noun'
                        {POS: "NOUN"},
                        # Optional (0 or 1 matches) of comma
                        {OP: '?', ORTH: ","},
                        # matches if token.lower_ == 'such'
                        {LOWER: "such"},
                        {LOWER: "as"},
                        {POS: "NOUN"}
                    ])
    
    # Match the document to the patterns
    matches = matcher(doc)
    
    # Extract the matches
    for ent_id, label, start, end in matches:
        span = doc[start:end]
        # First token is our noun_phrase_0
        np_0 = span[0]
        # Last token is noun_phrase_1
        np_1 = span[-1]
    
        # Extract the full list of hyponyms by search the noun phrase's subtree for more noun phrases
        np_list = [c for c in np_1.subtree if c.pos == NOUN]

        # Return a generator of the matched hyponyms in pairs
        # (X, Y) which means X is a type of Y
        for np in np_list:
            yield (np, np_0)
{% endhighlight %}


{% highlight python %}
for (x, y) in extract_hyponym("Please bring tools, such as a screwdriver, hammer and wrench."):
    print("hyponym({},{})".format(x, y))
{% endhighlight %}

    hyponym(a screwdriver,tools)
    hyponym(hammer,tools)
    hyponym(wrench,tools)


### References
  1. [Automatic Acquisition of Hyponyms from Large Text Corpora (Hearst 1992)](http://people.ischool.berkeley.edu/~hearst/papers/coling92.pdf)
  2. [Hyponymy and hypernymy Wikipedia](https://en.wikipedia.org/wiki/Hyponymy_and_hypernymy)

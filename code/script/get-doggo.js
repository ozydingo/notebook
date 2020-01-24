var LoremIpsum=function(){
};
LoremIpsum.WORDS_PER_SENTENCE_AVG=8;
LoremIpsum.WORDS_PER_SENTENCE_STD=4;
LoremIpsum.WORDS=["doggo","shibe","shoob","shoober","doggorino","shooberino","long doggo","length boy","noodle horse","long water shoob","aqua doggo","pupper","yapper","pupperino","wrinkler","puggorino","puggo","corgo","porgo","woofer","long woofer","sub woofer","heckin angery woofer","heckin good boys","floofs","fluffer","waggy wags","long bois","clouds","boofers","smol","big ol","doge","bork","borkf","mlem","blep","blop","pats","tungg","snoot","ruff","borkdrive","thicc","boof","h*ck","heck","heckin","vvv","heckin good boys and girls","big ol pupper","you are doing me a frighten","doing me a frighten","you are doing me the shock","ur givin me a spook","you are doin me a concern","stop it fren","maximum borkdrive","very good spot","adorable doggo","what a nice floof","the neighborhood pupper","borking doggo","many pats","lotsa pats","he made many woofs","dat tungg tho","smol borking doggo with a long snoot for pats","most angery pupper I have ever seen","wow such tempt","much ruin diet","wow very biscit","very hand that feed shibe","such treat","very taste wow","I am bekom fat","extremely cuuuuuute","very jealous pupper","super chub","fat boi"];

LoremIpsum.prototype.generate=function(num_words){
  var words,ii,position,word,current,sentences,sentence_length,sentence;
  num_words=num_words||100;
  words=[LoremIpsum.WORDS[0],LoremIpsum.WORDS[1]];
  num_words-=2;
  for(ii=0;ii<num_words;ii++){
    position=Math.floor(Math.random()*LoremIpsum.WORDS.length);
    word=LoremIpsum.WORDS[position];
    if(ii>0&&words[ii-1]===word){
      ii-=1;
    }else{
      words[ii]=word;
    }
  }
  sentences=[];
  current=0;
  while(num_words>0){
    sentence_length=this.getRandomSentenceLength();
    if(num_words-sentence_length<4){
      sentence_length=num_words;
    }
    num_words-=sentence_length;
    sentence=[];
    for(ii=current;ii<(current+sentence_length);ii++){
      sentence.push(words[ii]);
    }
    sentence=this.punctuate(sentence);
    current+=sentence_length;
    sentences.push(sentence.join(' '));
  }
  return sentences.join(' ');
};

LoremIpsum.prototype.punctuate=function(sentence){
  var word_length,num_commas,ii,position;
  word_length=sentence.length;
  sentence[word_length-1]+='.';
  if(word_length<4){
    return sentence;
  }
  num_commas=this.getRandomCommaCount(word_length);
  for(ii=0;ii<=num_commas;ii++){
    position=Math.round(ii*word_length/(num_commas+1));
    if(position<(word_length-1)&&position>0){
      sentence[position]+=',';
    }
  }
  sentence[0]=sentence[0].charAt(0).toUpperCase()+sentence[0].slice(1);
  return sentence;
};
LoremIpsum.prototype.getRandomCommaCount=function(word_length){
  var base,average,standard_deviation;
  base=6;
  average=Math.log(word_length)/Math.log(base);
  standard_deviation=average/base;
  return Math.round(this.gaussMS(average,standard_deviation));
};
LoremIpsum.prototype.getRandomSentenceLength=function(){
  return Math.round(this.gaussMS(LoremIpsum.WORDS_PER_SENTENCE_AVG,LoremIpsum.WORDS_PER_SENTENCE_STD));
};
LoremIpsum.prototype.gauss=function(){
  return(Math.random()*2-1)+
  (Math.random()*2-1)+
  (Math.random()*2-1);
};
LoremIpsum.prototype.gaussMS=function(mean,standard_deviation){
  return Math.round(this.gauss()*standard_deviation+mean);
};

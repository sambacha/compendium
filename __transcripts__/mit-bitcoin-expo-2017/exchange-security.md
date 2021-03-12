---
parent: Mit Bitcoin Expo 2017
title: Exchange Security.Md
Hidden: true
TranscriptBy: Bryan Bishop
---

---

layout: default parent: Mit Bitcoin Expo 2017 title: Exchange Security
nav_exclude: true transcript_by: Bryan Bishop

---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Exchange security

Mitchell Dong

2017-03-04

<https://www.youtube.com/watch?v=0mVOq1jaR1U&t=3h15m>

<https://twitter.com/kanzure/status/838517545783148545>

How often do you check your wallets? Have you ever looked in your wallet
and found all your bitcoin gone or missing? Last summer, somebody, a
friend of mine checked his wallet and found that 100,000 bitcoin was
gone. What the hell, right? But that's what happened at Bitfinex last
summer. Some hacker got into their hot wallet and stole 100,000 bitcoin.
This was $70 million bucks. Of which 1.5 million was mine.

I spent the last 6 months trying to figure out how to... to understand
it, how to manage it to minimize the chance of this happening again.
What have I studied in the past 6 months to try to prevent future
losses?

First some background on what happened last August 2016. On August 2nd,
the Bitfinex... let's see. No slides? What's that? Ah, it's over here.
Okay. Alright. How do I go back? I'm going forwards, so how do I go
back? Okay. I'll leave it on there.

So last August, when Bitfinex was hacked, 36% of all their digital
assets were stolen, both.. their digital assets. Bitfinex decided to not
go bankrupt like MtGox did. Instead what they decided to do was try to
continue and promise to pay back the people that lost the money. They
did that by issuing first of all they socialized all the losses. Even
though not all of the bitcoin--- as I said, 36% was stolen. None of the
whitecoin was taken, none of the cash was taken, only the bitcoin. They
first decided to socialize the losses. 36% of all their assets, everyone
took a haircut of 36%, no matter what assets you had or who you were.
And then they issued IOUs, promises to pay them back. These were in the
forms of digital tokens called BFX. These tokens were freely tradeable
on the exchange, they traded between $0.20 and $0.80 cents on the
dollar. This was a way for the market to predict whether they would get
their money back. Bitfinex offered to exchange these tokens into equity
in the company, at a price of about $200 million valuation. So $70
million losses converted into a company worth $200 million roughly. So
eveyrone who lost bitcoin, had the right to take 1/3rd of the company.
So people would be able to get back their losses and to enjoy the cash
flows of the company. We felt this was a better solution than MtGox
because in MtGox only the lawyers make it out okay. And here there is at
least a chance of you getting your money back.

Since then, we're a market maker and arbitrageurs. We look for price
differences. We buy in the US and sell in China. Buy in Europe, sell in
Japan, etc. On a second by second basis. We have to keep money on all
the 15 different exchanges. Having money on an exchange is counterparty
risk, which is the chance that the person you have your money with, goes
under, or they are hacked, or they steal the money, or there is some
loss. So we have to assess counterparty risk. What did we do to assess
that?

Well over, let me see if I can get that, so uh, what we did was we
first... this is a list of 16 different exchanges that we interviewed.
They are located in the US, China, Japan, Europe, a few other places.
They range from relatively early stage bitcoin exchanges to more mature
bitcoin exchanges. They range in volume from 100 bitcoin per day to
100,000 bitcoin per day. There's a mix between the big and the small. We
interviewed all the CEOs of these exchanges. We asked them some basic
questions. Some of the questions are showed here. How do you protect
your hot and cold wallets? How do you prevent internal fraud or
collusion? If there is a loss, would you cover customer losses? Do you
have those reserves? Financial health is very important. So we asked
whether they... I am not used to this laptop. Are you profitable? Do you
have insurance? Do you have a bitcoin or banking license? Do you have a
good relationship with regulators, with your bank? Tell us about
lawsuits you have against you. And what are the other securities?

We spent 3 months interviewing these CEOs, CTOs, CFOs, asking them all
these questions. I am going to summarize the lessons learned from this
interviewing process or survey, if you will. Integrated in this is, what
we believe are the best practices. One cautionary note is that-- these
results are generic to what we learned across all 16 exchanges. I'm
going to avoid making comment on any one particular exchange.

We like to do business with only profitable exchanges. Ones that have
financial resources to constantly invest in improving security. We like
exchanges where owners have a strong stake in keeping it going. If it's
not profitable, owners have less incentive to keep it going. If it's not
profitable, it's harder to attract tech talent, because we know how
highly paid they are. Next, we like big name VCs because they do a lot
of diligence. I like exchanges that have a relatively low burn rate. A
lot of this might sound common sense to you. That's one of my
conclusions.

We like CEOs who are highly communicative. During the Bitfinex hack, we
were speaking with the CEO and other management on an hourly basis until
things settled down. We avoid exchanges where CEOs are unwilling to
identify themselves or unwilling to have a phone call on a moment's
notice. If you have a problem, large or small, you want the CEO to
address it.

Next, we want to have CEOs that are very open aobut the inner workings
of their companies. What are the financial statements? Who controls the
keys to the cold wallet? Next, since bitcoin exchanges are private
companies, they usually don't disclose financial statements. So we have
to make common sense judgements about the people. Look at them eyeball
to eyeball and ask does their story make sense? Do you trust him? Does
he have a prior track record of success? How much does she have invested
in this? Is she hungry, or is she fat and happy? You want to trust
someone who has good jugement and will make good decisions especially in
a crisis.

Will you cover my losses if there is a big loss? If not, that's a
dealbreaker, we walk away. In some jurisdictions where there is a
banking license, it's a requirement that they cover customer losses. The
final point on this slide is that we like to do business with those who
have the cash to cover the losses.

Back in... a bitcoin exchange that has a bitcoin license or banking
license, is good where the regulators require that they have large cash
reserves to cover customer losses. Some licenses, you have to be
careful, do not require those reserves, such as those offered in Japan.
Having a license is no substitute for good license. In real estate, the
saying is location location location. In private equity, it's management
management management. As markets evolve, we only want to do business
with people who can evolve with the market and stay ahead.

We like exchanges that don't change their banks every few months, such
as those in China. This can be a yellow flag. We like CEOs who put their
customers ahead of their own interests. In the Bitfinex hack, their CEO
would tell me that his first priority was to compensate customers for
their losses before he gets his own money back. In our survey for
insurance, we only found 1 bitcoin exchange that had any kind of
insurance. I'm still skeptical, because insurance companies aren't in
the business of giving payouts, but rather collecting premiums.

In terms of internal fraud controls, how do you guard against collusion
of the top management? I just had a funny conversation the other day
with a Japanese exchange CEO and asked him what prevents him and his
colleagues from stealing all the bitcoin. He laughed and said I'm a
shareholder I'm not going to steal your money. There's nothing to
prevent the CEO of any exchange from walking out the door with all the
bitcoin. You want to put your money with the CEOs that have a greater
incentive to keep things running, rather than running out to Mongolia
and living as a fugitive. Many of the exchange CEOs we do business with
are now wealthy individuals. So why go to Siberia or Mongolia and have
an awful life as a fugitive?

Here's a question that we never got a satisfactory answer to. How do you
prevent against kidnapping of the top executives that hold the private
keys to the cold wallet? I don't think you can protect against this
unless you have a team of bodyguards. The way to prevent this is to not
tell anyone who has the private keys. And then give the private keys to
people across cities.

About the hot wallet, how do you prevent hacking against the hot wallet?
We like exchanges that keep as little as possible in the hot wallet, for
as little time as possible. I think Bitfinex's biggest mistake was
keeping everything in their hot wallet, no matter how good they thought
Bitgo was. Only keep the hot wallet hot for a few milliseconds. Do it in
small batches, do it multiple times a day. It reminds me of an old bank
robbery movie where the thiefs found that the bank truck drove past the
same spot every single day at the same exact time. The idea is to avoid
repeatable patterns.

How do you protect the cold wallet? Usually 90% of the bitcoin is in
there. So that's where the honey pot is. Taking the multisignature, keep
the keys and hardware in a vault, in different places, different cities,
restrict the access to the top 3 people and have reliable backups.

If the exchange provides leverage, how much margin does it offer to its
customer? Is it 3-to-1? 10-to-1? 50-to-1? 100-to-1? With the higher
leverage, it could potentially be a red flag. Whta happens if they are
lending money at 100:1 to buy bitcoin long, and then there's a 10% or
20% drop? This would result in negative equity. And then who takes the
loss? Do socialized losses across all the exchanges as the Chinese
companies do? or does the exchange absorb the loss? If the exchange
absorbs the loss, does it have sufficient cash reserves?

We like jurisdictions that have favorable regulatory environments for
Bitcoin, like NY state, Japan, Luxembourg, have very favorable
government regulations about bitcoin. An example of an unfavorable
regulatory environment would be China.

As a trader, we believe in diversification. We don't put more than 10%
of our digital assets in any one exchange. We learned htis the hard way
by having more than 40% of our assets in Bitfinex at the time of the
hack. As traders, we take our bitcoin out immediately to our own cold
wallet. Same with fiat. If the cash is not being immediately used, we
wire it to our own bank. If the exchange socializes their losses, we
want the assets out of their reach.

Finally, we monitor, monitor and monitor. We try to be vigilant about
watching our golden eggs. We look for yellow flags, we monitor all the
chatrooms, we go to the bitcoin conferences to pick up hints and clues.
In conclusion, as I said earlier, running a bitcoin business is no
different than running any other business with respect to its people. We
want to deal with knowledgeable, competent trustworthy people who run
profitable businesses. Before you put your money into any bitcoin
exchange or bitcoin company, use your common sense about the perceptions
of the people you're dealing with. If it smells bad, it's bad. Where
there is smoke, there is usually fire. Ask good questions and expect
good answers. If they avoid your questions, then avoid them. Do good due
diligence. Be a healthy skeptic. Hope for the best, but plan for the
worst.

The biggest danger in the bitcoin business is that you don't know what
you don't know. As a fund manager, people always ask me what my biggest
loss was historically. I tell them it's not exactly relevant, because
you're driving through the rear-view mirror. Your worst loss is always
ahead of you, not behind you. On the other hand, what doesn't kill you
makes you stronger, a smart person will come out stronger. When you do
suffer that future loss, I hope you will emerge stronger.

Thank you. Happy to answer any questions or comments and reactions.

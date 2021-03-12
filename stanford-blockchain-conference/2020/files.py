---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Files.Py
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %}
  <i>Transcript by: {{ page.transcript_by }}</i>
{% endif %}

root_url = "https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/"

file_data = [
    {
        "author": "#SBC20 Program Chairs",
        "stub": "welcome-remarks",
        "title": "Welcome remarks",
        "twitter": "",
        "pdf": "https://cbr.stanford.edu/sbc20/",
    },
    {
        "author": "Stefan Dziembowski",
        "stub": "lower-bounds-limits-plasma",
        "title": "Lower Bounds for Off-Chain Protocols: Exploring the Limits of Plasma",
        "twitter": "@SteDziembowski",
    },
    {
        "author": "Ed Felten",
        "stub": "arbitrum-v2",
        "title": "Arbitrum 2.0: Faster Off-Chain Contracts with On-Chain Security",
        "twitter": "@EdFelten",
    },
    {
        "author": "Assimakis Kattis",
        "stub": "proof-of-necessary-work",
        "title": "Proof of Necessary Work: Succinct State Verification with Fairness Guarantees",
        "twitter": "",
    },
    {
        "author": "Florian Tramer",
        "stub": "linking-anonymous-transactions",
        "title": "Linking anonymous transactions via remote side-channel attacks",
        "pdf": "https://crypto.stanford.edu/timings/paper.pdf",
        "twitter": "@florian_tramer",
    },
    {
        "author": "Daniel Perez",
        "stub": "attacking-evm-resource-metering",
        "title": "Broken Metre: Attacking resource meetering in EVM",
        "pdf": "https://arxiv.org/abs/1909.07220.pdf",
        "twitter": "@danhper @convoluted_code",
    },
    {
        "author": "Ben Maurer",
        "stub": "libra-blockchain-intro",
        "title": "The Libra Blockchain & Move: A technical introduction",
        "twitter": "@bmaurer",
    },
    {
        "author": "Brett Seyler",
        "stub": "blockchains-for-multiplayer-games",
        "title": "Blockchains for multiplayer games",
        "twitter": "",
    },
    {
        "author": "Marek Olszewski and Michael Straka",
        "stub": "celo-ultralight-client",
        "title": "The Celo ultralight client",
        "twitter": "@marekolszewski @CeloHQ",
    },
    {
        "author": "Eli Ben-Sasson",
        "stub": "stark-for-developers",
        "title": "STARK for developers",
        "twitter": "@EliBenSasson @starkwareltd",
    },
    {
        "author": "Ariel Gabizon",
        "stub": "plonk",
        "title": "PLONK: Permutations over Lagrange-bases for Oecumenical Noninteractive arguments of Knowledge",
        "pdf": "https://eprint.iacr.org/2019/pdf",
        "twitter": "@relgabizon @aztecprotocol",
    },
    {
        "author": "Nick Spooner",
        "title": "Fractal: Post-Quantum and Transparent Recursive Proofs from Holography",
        "stub": "fractal",
        "pdf": "https://eprint.iacr.org/2019/1076.pdf",
        "twitter": "",
    },
    {
        "author": "Megan Chen",
        "title": "Scalable RSA Modulus Generation with Dishonest Majority",
        "stub": "scalable-rsa-modulus-generation",
        "twitter": "",
    },
    {
        "author": "Simon Peffers",
        "title": "Hardware Accelerated RSA - VDFs, SNARKs, and Accumulators",
        "stub": "hardware-accelerated-rsa",
        "twitter": "@_Supranational",
    },
    {
        "author": "Ben Fisch",
        "title": "Transparent SNARKs from DARK compilers",
        "stub": "transparent-snarks-from-dark-compilers",
        "pdf": "https://eprint.iacr.org/2019/1229.pdf",
        "twitter": "@benafisch",
    },
    {
        "author": "Tim Roughgarden",
        "title": "An Axiomatic Approach to Block Rewards",
        "stub": "block-rewards",
        "pdf": "https://arxiv.org/pdf/1909.10645.pdf",
        "twitter": "@algo_class",
    },
    {
        "author": "Tarun Chitra",
        "title": "Competitive equilibria between staking and on-chain lending",
        "stub": "competitive-equilibria-staking-lending",
        "pdf": "https://arxiv.org/pdf/2001.00919v1.pdf",
        "twitter": "@tarunchitra",
    },
    {
        "author": "Vitalik Buterin",
        "title": "Beyond 51% attacks",
        "stub": "beyond-hashrate-majority-attacks",
        "twitter": "@VitalikButerin @ethereum",
    },
    {
        "author": "Benjamin Chan",
        "title": "Streamlet: Textbook Streamlined Blockchain Protocols",
        "stub": "streamlet",
        "twitter": "",
    },
    {
        "author": "Lei Yang",
        "title": "Prism: Scaling bitcoin by 10,000x",
        "stub": "prism",
        "pdf": "https://diyhpl.us/wiki/transcripts/scalingbitcoin/tel-aviv-2019/prism/",
        "twitter": "",
    },
    {
        "author": "David Tse",
        "title": "Proof-of-stake longest chain protocols revisited",
        "stub": "proof-of-stake",
        "twitter": "@Stanford",
    },
    {
        "author": "Fan Zhang",
        "title": "DECO: Liberating Web Data Using Decentralized Oracles for TLS",
        "stub": "decentralized-oracles-tls",
        "twitter": "@0xFanZhang",
    },
    {
        "author": "Ari Juels",
        "title": "Mixicles: Simple Private Decentralized Finance",
        "stub": "mixicles",
        "pdf": "https://chain.link/mixicles.pdf",
        "twitter": "@AriJuels",
    },
    {
        "author": "Mooly Sagiv",
        "title": "Finding Bugs Automatically in Smart Contracts with Parameterized Specifications",
        "stub": "smart-contract-bug-hunting",
        "pdf": "https://www.certora.com/pubs/sbc2020.pdf",
        "twitter": "@SagivMooly",
    },
    {
        "author": "Joachim Breitner",
        "title": "Motoko, the language for the Internet Computer",
        "stub": "motoko-language",
        "twitter": "@nomeata",
    },
    {
        "author": "Matteo Maffei",
        "title": "Atomic Multi-Channel Updates with Constant Collateral in Bitcoin-Compatible Payment-Channel Networks",
        "stub": "atomic-multi-channel-updates",
        "pdf": "https://diyhpl.us/wiki/transcripts/scalingbitcoin/tel-aviv-2019/atomic-multi-channel-updates/",
        "twitter": "@matteo_maffei",
    },
    {
        "author": "Joachim Neu",
        "title": "Boomerang: Redundancy Improves Latency and Throughput in Payment-Channel Network",
        "stub": "boomerang",
        "twitter": "",
    },
    {
        "author": "Georgia Avarikioti",
        "title": "Brick: Asynchronous State Channels",
        "stub": "brick-async-state-channels",
        "pdf": "https://arxiv.org/abs/1905.11360",
        "twitter": "@ETH_en",
    },
    {
        "author": "Karl Floersch",
        "title": "The optimistic VM",
        "stub": "optimistic-vm",
        "twitter": "@karl_dot_tech",
    },
    {
        "author": "Sreeram Kannan",
        "title": "Coded Merkle Tree: Solving Data Availability Attacks in Blockchains",
        "stub": "solving-data-availability-attacks-using-coded-merkle-trees",
        "pdf": "https://eprint.iacr.org/2019/1139.pdf",
        "twitter": "@sreeramkannan",
    },
    {
        "author": "David Schwartz",
        "title": "The best incentive is no incentive",
        "stub": "no-incentive",
        "twitter": "@ripple",
    },
    {
        "author": "Shayan Eskandari",
        "title": "Transparent dishonesty: frontrunning attacks on blockchain",
        "stub": "transparent-dishonesty",
        "twitter": "@sbetamc @ConsenSysAudits",
    },
    {
        "author": "Daniel Cline",
        "title": "ClockWork: An exchange protocol for proofs of non-front-running",
        "stub": "clockwork-nonfrontrunning",
        "twitter": "@rjected",
    },
]

for data in file_data:
    filename = data["stub"] + ".mdwn"
    url = root_url + data["stub"] + "/"
    title = data["title"]
    twitter = data["twitter"] + " @CBRStanford #SBC20"
    author = data["author"]

    if "pdf" in list(data.keys()):
        pdf = "\n\n<" + data["pdf"] + ">"
    else:
        pdf = ""

    sponsorship = "----\n\n<i>Sponsorship</i>: These transcripts are <a href=\"https://twitter.com/ChristopherA/status/1228763593782394880\">sponsored</a> by <a href=\"https://blockchaincommons.com/\">Blockchain Commons</a>.\n\n<i>Disclaimer</i>: These are unpaid transcriptions, performed in real-time and in-person during the actual source presentation. Due to personal time constraints they are usually not reviewed against the source material once published. Errors are possible. If the original author/speaker or anyone else finds errors of substance, please email me at kanzure@gmail.com for corrections or contribute online via github/git. I sometimes add annotations to the transcription text. These will always be denoted by a standard editor's note in parenthesis brackets ((like this)), or in a numbered footnote. I welcome feedback and discussion of these as well."

    tweet = f"Transcript: \"{title}\" {url} {twitter}"
    transcript = f"{title}\n\n{author}{pdf}\n\n\n{sponsorship}\n\nTweet: {tweet}\n"

    fd = open(filename, "w")
    fd.write(transcript)
    fd.close()


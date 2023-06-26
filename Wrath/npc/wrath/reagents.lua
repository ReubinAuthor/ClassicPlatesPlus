----------------------------------------
-- Reagent vendors
----------------------------------------
local _, core = ...;
local data = core.data;

data.reagents = {
    --Without description
    [25051] = 1, -- Merchant Frostwalker (Elune's Blessing)

    -- Reagents/Totems Vendor
    [5062] = 1, -- World Reagent Vendor

    -- Reagents, Herbs & Poison Supplies
    [3490] = 1, -- Hula'mahi

    -- Potions, Scrolls & Reagents
    [13476] = 1, -- Balai Lok'Wein

    -- Reagents & Magical Goods
    [29537] = 1, -- Darahir

    -- Poisons, Reagents & Alchemical Supplies
    [29909] = 1, -- Nilika Blastbeaker
    [30438] = 1, -- Supply Officer Thalmers

    -- Reagents & Poisons
    [29015] = 1, -- Shaman Partak
    [29037] = 1, -- Soo-jam

    -- Alchemy Supplies & Reagents
    [983] = 1, -- Thultazor
    [1257] = 1, -- Keldric Boucher
    [16612] = 1, -- Velanni
    [16706] = 1, -- Musal

    -- Reagents & Enchanting Supplies
    [26569] = 1, -- Alys Vol'tyr
    [27030] = 1, -- Bradley Towns
    [27039] = 1, -- Lexey Brevig
    [27054] = 1, -- Modoru

    -- Reagents and Poisons
    [24313] = 1, -- Celina Summers
    [24349] = 1, -- Jessica Evans
    [26382] = 1, -- Balfour Blackblade
    [26598] = 1, -- Mistie Flitterdawn
    [26950] = 1, -- Sanut Swiftspear

    -- Poison & Reagents
    [24357] = 1, -- Maethor Skyshadow
    [25736] = 1, -- Supply Master Taz'ishi
    [27133] = 1, -- Seer Yagnar
    [27149] = 1, -- Arrluk
    [27176] = 1, -- Mystic Makittuq
    [27186] = 1, -- Oogrooq

    -- Poisons & Reagents
    [3542] = 1, -- Jaysin Lanyda
    [29922] = 1, -- Corig the Cunning
    [29947] = 1, -- Apothecary Maple
    [29961] = 1, -- Brangrimm
    [29968] = 1, -- Hapanu Coldwind
    [30010] = 1, -- Fylla Ingadottir
    [30069] = 1, -- Initiate Roderick
    [30239] = 1, -- Alanura Firecloud
    [30244] = 1, -- Miura Brightweaver

    -- Reagents & Poison Supplies
    [5139] = 1, -- Kurdrum Barleybeard
    [10364] = 1, -- Yaelika Farclaw
    [19013] = 1, -- Vanteg
    [19014] = 1, -- Ogir
    [20081] = 1, -- Bortega
    [21642] = 1, -- Alrumi
    [22479] = 1, -- Sab'aoth
    [22652] = 1, -- Kurdrum Barleybeard
    [22660] = 1, -- Yaelika Farclaw
    [23145] = 1, -- Rumpus
    [37348] = 1, -- Kurdrum Barleybeard
    [37485] = 1, -- Yaelika Farclaw
    [32028] = 1, -- Kurdrum Barleybeard
    [32765] = 1, -- Yaelika Farclaw

    -- Reagent Vendor
    [25039] = 1, -- Kaalif

    -- Reagent Supplies
    [3970] = 1, -- Llana
    [25633] = 1, -- Arcanist Evandor
    [26984] = 1, -- Stephan Franks
    [27088] = 1, -- Yolanda Haymer
    [27138] = 1, -- Apprentice Rosen
    [27935] = 1, -- Ferithos

    -- Reagents
    [1275] = 1, -- Kyra Boucher
    [1308] = 1, -- Owen Vaughn
    [1351] = 1, -- Brother Cassius
    [1463] = 1, -- Falkan Armonis
    [1673] = 1, -- Alyssa Eva
    [2805] = 1, -- Deneb Walker
    [3323] = 1, -- Horthus
    [3335] = 1, -- Hagrus
    [3351] = 1, -- Magenius
    [3500] = 1, -- Tarhus
    [3562] = 1, -- Alaindia
    [3564] = 1, -- Temp Reagent Vendor Dwarf
    [3700] = 1, -- Jadenvis Seawatcher
    [4220] = 1, -- Cyroen
    [4562] = 1, -- Thomas Mordan
    [4575] = 1, -- Hannah Akeley
    [5110] = 1, -- Barim Jurgenstaad
    [5151] = 1, -- Ginny Longberry
    [8361] = 1, -- Chepi
    [14739] = 1, -- Mystic Yayo'jin
    [15175] = 1, -- Khur Hornstriker
    [16611] = 1, -- Zalle
    [16757] = 1, -- Bildine
    [16829] = 1, -- Magus Zabraxis
    [18017] = 1, -- Seer Janidi
    [18998] = 1, -- Lursa Sunfallow
    [19004] = 1, -- Vodesiin
    [19235] = 1, -- Amshesha Stilldark
    [19678] = 1, -- Fantei
    [20915] = 1, -- Noko Moonwhisper
    [23112] = 1, -- Mingo
    [23157] = 1, -- Aluyen
    [23560] = 1, -- Provisioner Ameenah
    [24409] = 1, -- Kyren
    [26474] = 1, -- Ameenah
    [26908] = 1, -- Helen Fairchild
    [26968] = 1, -- Drikka
    [28809] = 1, -- Vincent Huber
    [28827] = 1, -- Co'man
    [28870] = 1, -- Corpsedust
    [30792] = 1, -- Mingo
    [33871] = 1, -- Julie Osworth
    [30307] = 1, -- Sarhule the Risen

    -- Reagent Merchant
    [16015] = 1, -- Vi'el
    [18006] = 1, -- Noraani
    [29636] = 1, -- Hagatha Moorehead

    -- Poison Supplies
    [1326] = 1, -- Sloan McCoy
    [3090] = 1, -- Gerald Crawley
    [3135] = 1, -- Malissa
    [3334] = 1, -- Rekkul
    [3551] = 1, -- Patrice Dwyer
    [3559] = 1, -- Temp Poisoning Vendor Dwarf
    [3561] = 1, -- Kyrai
    [4585] = 1, -- Ezekiel Graves
    [6779] = 1, -- Smudge Thunderwood
    [16268] = 1, -- Eralan
    [16683] = 1, -- Darlia
    [16754] = 1, -- Fingle Dipswitch
    [19049] = 1, -- Karokka
    [20121] = 1, -- Fingin
    [26945] = 1, -- Zend'li Venomtusk
    [27089] = 1, -- Saffron Reynolds
    [28347] = 1, -- Miles Sidney

    -- Poison Supplier
    [23732] = 1, -- Sorely Twitchblade
    [25043] = 1, -- Sereth Duskbringer
    [28832] = 1, -- Chin'ika
    [28869] = 1, -- Deathdrip

    -- Poison Vendor
    [24148] = 1, -- David Marks
    [29535] = 1, -- Alchemist Cinesra

    -- Reagent and Poison Vendor
    [25312] = 1, -- Cel

    -- Herbalism & Poison Supplies
    [26568] = 1, -- Zebu'tan
    [27053] = 1, -- Lanus Longleaf

    -- Poison & Reagent Supplies
    [26900] = 1, -- Tinky Stabberson

    -- Alchemy & Poison Supplies
    [27031] = 1, -- Apothecary Rose
    [27038] = 1, -- Drolfy
    [29339] = 1, -- Apothecary Tepesh
    [29348] = 1, -- Apothecary Chaney

    -- Poisons
    [30306] = 1, -- Bileblow

    -- Enchanting Supplies
    [28714] = 1, -- Ildine Sorrowspear

    -- Arcane Trinkets Vendor
    [1307] = 1, -- Charys Yserian
};
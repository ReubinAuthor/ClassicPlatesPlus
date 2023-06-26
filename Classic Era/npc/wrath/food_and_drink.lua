----------------------------------------
-- Food & drink vendors
----------------------------------------
local _, core = ...;
local data = core.data;

data.food_and_drink = {
    -- Without description
    [11287] = 1, -- Baker Masterson
    [233] = 1, -- Farmer Saldean
    [25052] = 1, -- Galley Chief Halumvorea (Elune's Blessing)

    -- Drink vendor
    [4192] = 1, -- Taldan
    [6495] = 1, -- Riznek
    [18954] = 1, -- Sailor Melinan
    [23110] = 1, -- Ogri'la Keg King
    [30796] = 1, -- Ogri'la Keg King (1)

    -- Darkmoon Faire Drink Vendor
    [14844] = 1, -- Sylannia

    -- Darkmoon Faire Food Vendor
    [14845] = 1, -- Stamp Thunderhorn

    -- Wine vendor
    [1301] = 1, -- Julia Gallina
    [19245] = 1, -- Vinemaster Alamaro
    [23525] = 1, -- Brother Cartwright
    [23606] = 1, -- Suntouched Apprentice
    [32337] = 1, -- Christi Stockton

    -- Bread merchant
    [19664] = 1, -- Muffin Man Moser
    [1670] = 1, -- Mike Miller

    -- Meat vendor
    [3025] = 1, -- Kaga Mistrunner
    [3312] = 1, -- Olvia
    [3368] = 1, -- Borstan
    [4169] = 1, -- Jaeana
    [5124] = 1, -- Sognar Cliffbeard
    [23263] = 1, -- Brendan Turner
    [31425] = 1, -- Olvia

    -- Butcher
    [2365] = 1, -- Bront Coldcleave
    [2814] = 1, -- Narj Deepslice
    [3089] = 1, -- Sherman Femmel
    [3411] = 1, -- Denni'ka
    [3489] = 1, -- Zargh
    [3705] = 1, -- Gahroot
    [3881] = 1, -- Grimtak
    [3882] = 1, -- Zlagk
    [3933] = 1, -- Hai'zan
    [3935] = 1, -- Toddrick
    [3960] = 1, -- Ulthaan
    [4875] = 1, -- Turhaw
    [4879] = 1, -- Ogg'marr
    [4954] = 1, -- Uttnar
    [5870] = 1, -- Krond
    [8125] = 1, -- Dirge Quikcleave
    [12039] = 1, -- Aerie Peak Meat Vendor
    [21084] = 1, -- Braagor
    [24343] = 1, -- Brock Olson
    [29244] = 1, -- Jesse Masters
    [29905] = 1, -- Grillix Bonesaw

    -- Superior Butcher
    [2818] = 1, -- Slagg

    -- Fruit seller
    [894] = 1, -- Homer Stonefield
    [1671] = 1, -- Lamar Veisilli
    [19223] = 1, -- Granny Smith

    -- Fruit vendor
    [3017] = 1, -- Nan Mistrunner
    [3342] = 1, -- Shan'ti
    [7978] = 1, -- Bimble Longberry
    [29547] = 1, -- Applebough

    -- Ice Cream Vendor
    [6496] = 1, -- Brivelthwerp

    -- Pie vendor
    [9099] = 1, -- Sraaz

    -- Mushroom seller
    [3138] = 1, -- Scott Carevin
    [3544] = 1, -- Jason Lemieux

    -- Fungus vendor
    [4571] = 1, -- Morley Bates

    -- fish vendor
    [4200] = 1, -- Laird
    [4221] = 1, -- Talaelar
    [7943] = 1, -- Harklane
    [31019] = 1, -- Stephanie Sindree

    -- Bread vendor
    [3003] = 1, -- Fyr Mistrunner
    [5109] = 1, -- Myra Tyrngaarde
    [23522] = 1, -- Arlen Lochlan
    [23603] = 1, -- Uta Roughdough

    -- Bread & cheese vendor
    [29714] = 1, -- Lucian Trias

    -- Pie, Pastry & Cakes
    [29548] = 1, -- Aimee

    -- Baker
    [3480] = 1, -- Moorane Hearthgrain
    [3518] = 1, -- Thomas Miller
    [3883] = 1, -- Moodan Sungrain
    [3884] = 1, -- Jhawna Oatwind
    [3948] = 1, -- Honni Goldenoat
    [3959] = 1, -- Nantar
    [4190] = 1, -- Kyndri
    [8307] = 1, -- Tarban Hearthgrain

    -- Traveling baker
    [3937] = 1, -- Kira Songshine

    -- Barmaid
    [1328] = 1, -- Elly Langston
    [5112] = 1, -- Gwenna Firebrew
    [5140] = 1, -- Edris Barleybeard
    [19186] = 1, -- Kylene
    [20401] = 1, -- Frances Lin
    [28682] = 1, -- Inzi Charmlight
    [28685] = 1, -- Narisa Redgold
    [32403] = 1, -- Sandra Bartan
    [32419] = 1, -- Umbiwa'
    [32420] = 1, -- Mimbihi
    [32421] = 1, -- Marcella Bloom

    -- Bartender
    [274] = 1, -- Barkeep Hann
    [465] = 1, -- Barkeep Dobbins
    [1305] = 1, -- Jarel Moor
    [1311] = 1, -- Joachim Brenlow
    [2366] = 1, -- Barkeep Kelly
    [4782] = 1, -- Truk Wildbeard
    [4893] = 1, -- Bartender Lillian
    [4963] = 1, -- Mikhail
    [5570] = 1, -- Bruuk Barleybeard
    [18783] = 1, -- Sabille
    [19182] = 1, -- Shaarubo
    [20377] = 1, -- Barkeep Kelly
    [23737] = 1, -- Coot "The Stranger" Albertson
    [24333] = 1, -- Bartender Jason Goodhutch
    [29049] = 1, -- Arille Azuregaze
    [32415] = 1, -- Hamaka
    [32416] = 1, -- Stefen Cotter
    [33019] = 1, -- Megan Owings

    -- Food & drink
    [982] = 1, -- Thultash
    [1237] = 1, -- Kazan Mogosh
    [2303] = 1, -- Lyranne Feathersong
    [2832] = 1, -- Nixxrax Fillamug
    [3298] = 1, -- Gabrielle Chase
    [3546] = 1, -- Bernie Heisten
    [3621] = 1, -- Kurll
    [3689] = 1, -- Laer Stepperunner
    [3708] = 1, -- Gruna
    [3961] = 1, -- Maliynn
    [4167] = 1, -- Dendrythis
    [4181] = 1, -- Fyrenna
    [4191] = 1, -- Allyndia
    [4195] = 1, -- Tiyani
    [4255] = 1, -- Brogus Thunderbrew
    [4266] = 1, -- Danlyia
    [5620] = 1, -- Bartender Wental
    [6091] = 1, -- Dellylah
    [7485] = 1, -- Nargatt
    [7941] = 1, -- Mardrack Greenwell
    [8143] = 1, -- Loorana
    [8148] = 1, -- Waurg
    [8150] = 1, -- Janet Hommers
    [8152] = 1, -- Harnor
    [10367] = 1, -- Shrye Ragefist
    [11187] = 1, -- Himmik
    [12019] = 1, -- Dargon
    [12026] = 1, -- My'lanna
    [16443] = 1, -- Zalene Firstlight
    [16585] = 1, -- Cookie One-Eye
    [16798] = 1, -- Provisioner Anir
    [17277] = 1, -- Provisioner Valine
    [17656] = 1, -- Heron Skygaze
    [19050] = 1, -- Garul
    [19348] = 1, -- Targrom
    [19518] = 1, -- Feranin
    [19559] = 1, -- Mondul
    [19572] = 1, -- Gant
    [20893] = 1, -- Morula
    [20916] = 1, -- Xerintha Ravenoak
    [21484] = 1, -- Embelar
    [21487] = 1, -- Cendrii
    [22646] = 1, -- Brogus Thunderbrew
    [22655] = 1, -- Shrye Ragefist
    [23573] = 1, -- Krixil Slogswitch
    [23748] = 1, -- Kurzel
    [26110] = 1, -- Librarian Serrah
    [26567] = 1, -- Aegalas
    [27044] = 1, -- Ordal McLumpkins
    [27137] = 1, -- Apprentice Fraser
    [29121] = 1, -- Soo-yum
    [29122] = 1, -- Rarkag
    [29205] = 1, -- Corpulous
    [29275] = 1, -- Aspen Grove Supplier
    [29715] = 1, -- Fialla Sweetberry
    [30254] = 1, -- Marisalira
    [30255] = 1, -- Aniduria
    [30309] = 1, -- Shambles
    [30439] = 1, -- Sister Colleen Tulley
    [31926] = 1, -- Brogus Thunderbrew
    [32078] = 1, -- Shrye Ragefist
    [32412] = 1, -- Mato
    [32478] = 1, -- Slosh
    [33018] = 1, -- Jennifer Owings
    [37242] = 1, -- Brogus Thunderbrew
    [37399] = 1, -- Shrye Ragefist
}
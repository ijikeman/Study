require 'hbaserb'

client = HBaseRb::Client.new 'db'
table = client.create_table "test", "fam1", "fam2"
table.mutate_row "1", {'fam1:hoge' => 'hoge', 'fam1:fuga' => 'fuga', 'fam2:count' => "1"}
table.mutate_row "2", {'fam1:hoge' => 'foo', 'fam1:fuga' => 'bar', 'fam2:count' => "1"}


client2 = HBaseRb::Client.new 'db'
table = client2.get_table "test"
row = table.get_row("2").first
p row.columns["fam1:hoge"].value
p row.columns["fam1:fuga"].value
p row.columns["fam2:count"].value

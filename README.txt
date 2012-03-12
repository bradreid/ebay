How To Use
^^^^^^^^^^

1) Ebay time

ruby-1.8.7-p334 :011 > Ebay::Shopping.new.eBayTime
 => Mon Mar 12 20:13:38 UTC 2012 


2) Find items by category

ruby-1.8.7-p334 :013 > Ebay::Finding.new.find_items_by_category.first.title
 => "1965 Piper Cherokee 180 Single Engine" 


3)  Find item by id

ruby-1.8.7-p334 :018 > Ebay::Finding.new.get_item(330697357074).Title
 => "76 B58 Baron!! Loaded!! Cheap!!!"
 
 How To Configure
 ^^^^^^^^^^^^^^^^
 
 If using gem on its own, edit config/ebay.yml.  If using in a RoR app, edit config/ebay.yml
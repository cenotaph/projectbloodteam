class PopulateExchangeTable < ActiveRecord::Migration
  def self.up
    # USD to GBP
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2002-12-31', :rate => 0.6663)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2003-12-31', :rate => 0.6122)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2004-12-31', :rate => 0.5460)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2005-12-31', :rate => 0.5500)                        
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2006-12-31', :rate =>0.5435)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2007-12-31', :rate => 0.4998)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2008-12-31', :rate => 0.5448)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2009-12-31', :rate => 0.6410)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 0.6474)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2011-12-31', :rate => 0.6236)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2012-12-31', :rate => 0.6311)
    # USD to EUR
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 3, 
                    :entire_year => true, :sample_date => '2002-12-31', :rate => 1.0608)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 3, 
                    :entire_year => true, :sample_date => '2003-12-31', :rate => 0.8852)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 3, 
                    :entire_year => true, :sample_date => '2004-12-31', :rate => 0.8050 )
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 3, 
                    :entire_year => true, :sample_date => '2005-12-31', :rate => 0.8044)                        
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 3, 
                    :entire_year => true, :sample_date => '2006-12-31', :rate => 0.7969)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 3, 
                    :entire_year => true, :sample_date => '2007-12-31', :rate => 0.7307)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 3, 
                    :entire_year => true, :sample_date => '2008-12-31', :rate => 0.6833)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 3, 
                    :entire_year => true, :sample_date => '2009-12-31', :rate => 0.7191)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 3, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 0.7548)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 3, 
                    :entire_year => true, :sample_date => '2011-12-31', :rate => 0.7189)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 3, 
                    :entire_year => true, :sample_date => '2012-12-31', :rate => 0.7782
)

    # EUR to GBP
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2002-12-31', :rate => 0.6287)
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2003-12-31', :rate => 0.6921)
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2004-12-31', :rate => 0.6786 )
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2005-12-31', :rate => 0.6840)                        
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2006-12-31', :rate => 0.6818)
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2007-12-31', :rate => 0.6846)
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2008-12-31', :rate => 0.7961)
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2009-12-31', :rate => 0.8914)
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 0.8586)
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2011-12-31', :rate => 0.8680)
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 2, 
                    :entire_year => true, :sample_date => '2012-12-31', :rate => 0.8113)    

    # US to AUS
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 4, 
                    :entire_year => true, :sample_date => '2007-12-31', :rate => 1.1947)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 4, 
                    :entire_year => true, :sample_date => '2009-12-31', :rate => 1.2805) 
    # GBP to AUS
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 4, 
                    :entire_year => true, :sample_date => '2007-12-31', :rate => 2.3899)
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 4, 
                    :entire_year => true, :sample_date => '2009-12-31', :rate => 1.9920) 
    # EUR to AUS
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 4, 
                    :entire_year => true, :sample_date => '2007-12-31', :rate => 1.6352)
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 4, 
                    :entire_year => true, :sample_date => '2009-12-31', :rate => 1.7752)


    # US to SEK
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 8, 
                    :entire_year => true, :sample_date => '2006-12-31', :rate => 7.3756)    
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 8, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 7.2046)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 8, 
                    :entire_year => true, :sample_date => '2011-12-31', :rate => 6.4913) 
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 8, 
                    :entire_year => true, :sample_date => '2012-12-31', :rate => 6.7736) 

    # GBP to SEK
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 8, 
                    :entire_year => true, :sample_date => '2006-12-31', :rate => 13.5711)    
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 8, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 11.1261)
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 8, 
                    :entire_year => true, :sample_date => '2011-12-31', :rate => 10.4061) 
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 8, 
                    :entire_year => true, :sample_date => '2012-12-31', :rate => 10.7328)                        
    # EUR to SEK
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 8, 
                    :entire_year => true, :sample_date => '2006-12-31', :rate => 9.2541)    
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 8, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 9.5497)
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 8, 
                    :entire_year => true, :sample_date => '2011-12-31', :rate => 9.0312) 
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 8, 
                    :entire_year => true, :sample_date => '2012-12-31', :rate => 8.7075) 

    # US to EEK
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 13, 
                    :entire_year => true, :sample_date => '2008-12-31', :rate => 10.6918)    
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 13, 
                    :entire_year => true, :sample_date => '2009-12-31', :rate => 11.2529)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 13, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 11.8091)
    # GBP to EEK
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 13, 
                    :entire_year => true, :sample_date => '2008-12-31', :rate => 19.7040)    
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 13, 
                    :entire_year => true, :sample_date => '2009-12-31', :rate => 17.5693)
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 13, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 18.2375)                        
    # EUR to EEK
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 13, 
                    :entire_year => true, :sample_date => '2008-12-31', :rate => 15.6466)    
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 13, 
                    :entire_year => true, :sample_date => '2009-12-31', :rate => 15.6466)
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 13, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 15.6466)

    # USD to INR
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 5, 
                    :entire_year => true, :sample_date => '2004-12-31', :rate => 45.2705) 
    # GBP to INR
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 5, 
                    :entire_year => true, :sample_date => '2004-12-31', :rate => 84.9664) 
    # EUR to INR
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 5, 
                    :entire_year => true, :sample_date => '2004-12-31', :rate => 56.2904) 


    # USD to THB
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 6, 
                    :entire_year => true, :sample_date => '2007-12-31', :rate => 32.2919) 
    # GBP to THB
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 6, 
                    :entire_year => true, :sample_date => '2007-12-31', :rate => 64.5951) 
    # GBP to THB
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 6, 
                    :entire_year => true, :sample_date => '2007-12-31', :rate => 44.2016)

    # USD to PLN
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 10, 
                    :entire_year => true, :sample_date => '2006-12-31', :rate => 3.1036)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 10, 
                    :entire_year => true, :sample_date => '2012-12-31', :rate => 3.2555)     
    # GBP to PLN
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 10, 
                    :entire_year => true, :sample_date => '2006-12-31', :rate => 5.7128) 
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 10, 
                    :entire_year => true, :sample_date => '2012-12-31', :rate => 5.1574)     
    # GBP to PLN
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 10, 
                    :entire_year => true, :sample_date => '2006-12-31', :rate => 3.8955)
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 10, 
                    :entire_year => true, :sample_date => '2012-12-31', :rate => 4.1831)

    # USD to JPY
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 12, 
                    :entire_year => true, :sample_date => '2004-12-31', :rate => 108.15) 
    # GBP to JPY
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 12, 
                    :entire_year => true, :sample_date => '2004-12-31', :rate => 198.12) 
    # EUR to JPY
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 12, 
                    :entire_year => true, :sample_date => '2004-12-31', :rate => 134.42)


    # USD to AED
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 11, 
                    :entire_year => true, :sample_date => '2004-12-31', :rate => 3.6730) 
    # GBP to AED
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 11, 
                    :entire_year => true, :sample_date => '2004-12-31', :rate => 6.7309) 
    # EUR to AED
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 11, 
                    :entire_year => true, :sample_date => '2004-12-31', :rate => 4.5679)



    # USD to SGD
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 14, 
                    :entire_year => true, :sample_date => '2009-12-31', :rate => 1.4541) 
    # GBP to SGD
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 14, 
                    :entire_year => true, :sample_date => '2009-12-31', :rate => 2.2730) 
    # EUR to SGD
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 14, 
                    :entire_year => true, :sample_date => '2009-12-31', :rate => 2.0245)


    # USD to RUB
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 15, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 30.3713) 
    # GBP to RUB
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 15, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 46.9512) 
    # EUR to RUB
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 15, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 40.3027)

    # US to DKK
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 9, 
                    :entire_year => true, :sample_date => '2006-12-31', :rate => 5.9437)    
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 9, 
                    :entire_year => true, :sample_date => '2009-12-31', :rate => 5.3550)
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 9, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 5.6215)
    # GBP to DKK
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 9, 
                    :entire_year => true, :sample_date => '2006-12-31', :rate => 10.9399)    
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 9, 
                    :entire_year => true, :sample_date => '2009-12-31', :rate => 8.3607)
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 9, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 8.6818)                        
    # EUR to DKK
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 9, 
                    :entire_year => true, :sample_date => '2006-12-31', :rate => 7.4592)    
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 9, 
                    :entire_year => true, :sample_date => '2009-12-31', :rate => 7.4463)
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 9, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 7.4473)


    # US to LVL
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 16, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 0.5348)   
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 16, 
                    :entire_year => true, :sample_date => '2012-12-31', :rate => 0.5426)     
    # US to LTL
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 17, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 2.6062)
    # US to NOK
    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 18, 
                    :entire_year => true, :sample_date => '2012-12-31', :rate => 5.8199) 

    Exchange.create(:basecurrency_id => 1, :othercurrency_id => 19, 
                    :entire_year => true, :sample_date => '2012-12-31', :rate => 29.5762) 

    # GBP to LVL
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 16, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 0.8260)
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 16, 
                    :entire_year => true, :sample_date => '2012-12-31', :rate => 0.8598)
    #GBP to LTL                 
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 17, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 4.0249)
    # GBP to NOK  
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 18, 
                    :entire_year => true, :sample_date => '2012-12-31', :rate => 9.2213) 
    Exchange.create(:basecurrency_id => 2, :othercurrency_id => 19, 
                    :entire_year => true, :sample_date => '2012-12-31', :rate => 46.8697)     

    # EUR to LVL
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 16, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 0.7086)
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 16, 
                    :entire_year => true, :sample_date => '2012-12-31', :rate => 0.6973)  
    # EUR to LTL                     
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 17, 
                    :entire_year => true, :sample_date => '2010-12-31', :rate => 3.4530)
    # EUR to NOK
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 18, 
                    :entire_year => true, :sample_date => '2012-12-31', :rate => 7.4799) 
    Exchange.create(:basecurrency_id => 3, :othercurrency_id => 19, 
                    :entire_year => true, :sample_date => '2012-12-31', :rate => 38.0260) 



  end

  def self.down
  end
end

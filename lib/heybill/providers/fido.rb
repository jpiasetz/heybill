module Heybill
  module Providers
    class Fido < Heybill::Provider
      ask :phone_number
      ask :password

      log_in do
        login_url = 'https://www.fido.ca/web/page/portal/Fido/Ecare_Standalone'
        visit login_url
        within('#fidoNumberSection') do
          fill_in 'fidoNumber', with: @phone_number
          fill_in 'passwordField', with: @password
          within('#signInButton') do
            find('img').click
          end
        end
      end

      fetch_bills do
        visit 'https://www.fido.ca/web/page/portal/Fido/Ecare_ViewOnlineBilling_land&viewBillNoRedirect=true'
        links = all('tr #link01 a').map { |el| el[:href] }
        puts links
        links.each do |link|
          visit link
          puts current_url
          puts page.html
          url = /var docURL=  '([^']*)'/.match(page.html).captures.replace('HTML', 'PDF')
          puts url
        end
      end
    end
  end
end

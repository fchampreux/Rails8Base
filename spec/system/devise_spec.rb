require 'rails_helper'

RSpec.describe "Devise", type: :system do
  let(:password) { "Password123!" }
  let!(:user) { create(:user, password: password, password_confirmation: password) }

  before { ActionMailer::Base.deliveries.clear }

  # ---------------------------------------------------------------------------
  describe "Sign in" do
    context "avec des identifiants valides" do
      it "authentifie via l'email" do
        sign_in_via_form(user.email, password)
        expect(page).to have_selector("[aria-label='Fermer la session']")
      end

      it "authentifie via le code utilisateur" do
        sign_in_via_form(user.code, password)
        expect(page).to have_selector("[aria-label='Fermer la session']")
      end
    end

    context "avec des identifiants invalides" do
      it "affiche une erreur sur mot de passe incorrect" do
        sign_in_via_form(user.email, "mauvais_mdp")
        expect(page).to have_content("Invalid")
      end

      it "affiche une erreur sur email inconnu" do
        sign_in_via_form("inconnu@example.com", password)
        expect(page).to have_content("Invalid")
      end
    end
  end

  # ---------------------------------------------------------------------------
  describe "Sign out", js: true do
    it "ferme la session et affiche l'icône de connexion" do
      sign_in_via_form(user.email, password)
      find("[aria-label='Fermer la session']").click
      expect(page).to have_selector("[aria-label='Ouvrir une session']")
    end
  end

  # ---------------------------------------------------------------------------
  describe "Confirmable" do
    context "compte non confirmé" do
      let!(:unconfirmed) do
        create(:user, :unconfirmed, password: password, password_confirmation: password)
      end

      it "bloque la connexion et demande la confirmation" do
        sign_in_via_form(unconfirmed.email, password)
        expect(page).to have_content("confirm your email address")
      end
    end
  end

  # ---------------------------------------------------------------------------
  describe "Registration" do
    it "crée un compte et envoie un email de confirmation" do
      visit new_user_registration_path
      fill_in "Code",                  with: "newuser"
      fill_in "First name",            with: "Jane"
      fill_in "Last name",             with: "Doe"
      fill_in "Email",                 with: "jane@example.com"
      fill_in "Password",              with: password
      fill_in "Password confirmation", with: password
      click_button "Sign up"

      expect(ActionMailer::Base.deliveries.last&.to).to include("jane@example.com")
    end

    it "affiche les erreurs si les champs requis sont absents" do
      visit new_user_registration_path
      click_button "Sign up"
      expect(page).to have_content("can't be blank")
    end
  end

  # ---------------------------------------------------------------------------
  describe "Password recovery" do
    it "envoie les instructions de réinitialisation par email" do
      visit new_user_password_path
      fill_in "Email", with: user.email
      click_button "Send reset instructions"

      expect(ActionMailer::Base.deliveries.last&.to).to include(user.email)
    end
  end

  # ---------------------------------------------------------------------------
  describe "Lockable" do
    it "verrouille le compte après 5 tentatives échouées" do
      5.times { sign_in_via_form(user.email, "mauvais_mdp") }
      expect(page).to have_content("locked")
    end
  end

  # ---------------------------------------------------------------------------
  describe "Trackable" do
    it "incrémente sign_in_count à chaque connexion réussie" do
      expect { sign_in_via_form(user.email, password) }
        .to change { user.reload.sign_in_count }.by(1)
    end
  end
end

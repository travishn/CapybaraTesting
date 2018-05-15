require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #new' do
    it 'renders new users template' do
      get :new

      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'logs the user in' do
        post :create, params: { user: { username: 'BobTheBuilder', email: 'bob@bob.com', password: 'password' } }
        bob = User.find_by(username: 'BobTheBuilder')
        expect(session[:session_token]).to eq(bob.session_token)
      end

      it 'redirects the user to his/her profile page' do
        post :create, params: { user: { username: 'BobTheBuilder', email: 'bob@bob.com', password: 'password' } }
        bob = User.find_by(username: 'BobTheBuilder')

        expect(response).to redirect_to(profile_url(bob))
      end
    end

    context 'with invalid params' do
      it 'flashes errors and renders new template' do
          post :create, params: { user: { username: 'BobTheBuilder', password: 'password' } }
          expect(response).to render_template(:new)
          expect(flash[:errors]).to be_present
      end
    end
  end
end

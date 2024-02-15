/// <reference types="cypress" />

describe('Login NSS', () => {
  it('Login test for NSS', () => {
    	// Given I visit the Home page
		cy.visit('https://server/profile/card#me')

		// I see the login button
		cy.get('input[type="button"][value="Log in"]').should('be.visible')

		// I log in with a valid user
		cy.get('input[type="button"][value="Log in"]').click()
		cy.get('button').contains('server').click()
		cy.get('input[name="username"]').type('alice')
		cy.get('input[name="password"]').type('123')
		cy.get('button[id="login"]').click()
  })
})

/// <reference types="cypress" />

describe('Login NSS', () => {
  it('Login test for NSS', () => {
    	// Given I visit the Home page
		cy.visit('https://server')

		// I see the login button
		cy.get('button[name="login"]').should('be.visible')

		// I log in with a valid user
		cy.get('form[name="login"]').within(() => {
			cy.get('input[name="user"]').type('alice')
			cy.get('input[name="password"]').type('test123')
			cy.get('button[id="submit"]').click()
		})

		// Then I see that the current page is the Files app
		cy.url().should('match', /apps\/files(\/|$)/)
  })
})

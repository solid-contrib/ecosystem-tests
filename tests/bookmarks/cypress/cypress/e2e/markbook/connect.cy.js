/// <reference types="cypress" />

describe('Connect NSS', () => {
    it('Connect test for NSS', () => {
          // Given I visit the Home page
          cy.visit('http://markbook:3001')
  
          // I see the login button
          cy.get('a.navbar-burger.burger').should('be.visible')
  
          // I log in with a valid user
          cy.get('a.navbar-burger.burger').click()
          cy.get('a[id="login"]').click()
          cy.get('span').contains('Log in with custom provider').click()
        //   type('alice')
        //   cy.get('input[name="password"]').type('123')
        //   cy.get('button[id="login"]').click()
    })
  })
  
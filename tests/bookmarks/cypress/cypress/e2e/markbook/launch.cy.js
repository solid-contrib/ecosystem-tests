/// <reference types="cypress" />

describe('Launch markbook', () => {
    it('Launch markbook', () => {
          // Given I visit the Home page
          cy.visit('http://launcher:3000')
  
          // I see the login button
          cy.get('span').contains('Log in').should('be.visible')
  
          // I log in with a valid user
          cy.get('span').contains('Log in').click()
          cy.get('a[id="login"]').click()
          cy.get('span').contains('Log in with custom provider').click()
        //   type('alice')
        //   cy.get('input[name="password"]').type('123')
        //   cy.get('button[id="login"]').click()
    })
  })
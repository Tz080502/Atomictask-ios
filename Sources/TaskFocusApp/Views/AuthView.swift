import SwiftUI

struct AuthView: View {
    @ObservedObject private var viewModel = AuthViewModel()
    @State private var isSignUp = false
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                VStack(spacing: 12) {
                    Text("Atomic Task")
                        .font(.custom("ABCGintoRoundedUnlicensedTrial-Black", size: 42))
                        .foregroundColor(.textDark)
                    
                    Text("One task at a time")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.textDark.opacity(0.7))
                }
                .padding(.bottom, 40)
                
                VStack(spacing: 16) {
                    TextField("EMAIL", text: $viewModel.email)
                        .textFieldStyle(CustomTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                    
                    SecureField("PASSWORD", text: $viewModel.password)
                        .textFieldStyle(CustomTextFieldStyle())
                }
                .padding(.horizontal, 32)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.accentRed)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                VStack(spacing: 12) {
                    Button(action: {
                        _Concurrency.Task {
                            if isSignUp {
                                await viewModel.signUp()
                            } else {
                                await viewModel.signIn()
                            }
                        }
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                        } else {
                            Text(isSignUp ? "Sign Up" : "Sign In")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                        }
                    }
                    .background(Color.accentBlue)
                    .cornerRadius(12)
                    .disabled(viewModel.isLoading)
                    
                    Button(action: {
                        isSignUp.toggle()
                        viewModel.errorMessage = nil
                    }) {
                        Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                            .font(.system(size: 14))
                            .foregroundColor(.accentBlue)
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
            }
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.borderStroke, lineWidth: 1)
            )
            .foregroundColor(.textDark)
    }
}

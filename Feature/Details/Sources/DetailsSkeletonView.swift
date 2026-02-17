//
//  DetailsSkeletonView.swift
//  Details
//
//  Created by Esekiel Surbakti on 12/02/26.
//

import Design

struct DetailsSkeletonView: View {
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                skeleton()
                    .aspectRatio(16 / 9, contentMode: .fit)
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        skeleton().frame(width: 200, height: 24)
                        skeleton().frame(width: 160, height: 14)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        skeleton().frame(height: 14)
                        skeleton().frame(height: 14)
                        skeleton().frame(height: 14)
                        skeleton().frame(width: 200, height: 14)
                    }
                    
                    skeleton().frame(width: 180, height: 14)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        skeleton().frame(width: 40, height: 18)
                        HStack(spacing: 12) {
                            ForEach(0..<4, id: \.self) { _ in
                                VStack(spacing: 6) {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 56, height: 56)
                                    skeleton().frame(width: 60, height: 10)
                                    skeleton().frame(width: 50, height: 10)
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        skeleton().frame(width: 40, height: 18)
                        skeleton().frame(width: 120, height: 14)
                        skeleton().frame(width: 140, height: 14)
                    }
                }
                .padding(16)
            }
        }
        .shimmerEffect()
    }
    
    private func skeleton() -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

#Preview {
    DetailsSkeletonView()
}

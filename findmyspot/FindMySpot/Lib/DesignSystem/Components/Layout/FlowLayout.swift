//
//  FlowLayout.swift
//  FindMySpot
//
//  Created by josiaschweizer on 02.10.2026.
//
import SwiftUI

struct FlowLayout: Layout {
    enum Alignment {
        case leading, center, trailing
    }

    var horizontalSpacing: CGFloat
    var verticalSpacing: CGFloat
    var alignment: Alignment

    init(
        horizontalSpacing: CGFloat = AppSpacing.sm,
        verticalSpacing: CGFloat = AppSpacing.sm,
        alignment: Alignment = .leading
    ) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.alignment = alignment
    }

    init(spacing: CGFloat, alignment: Alignment = .leading) {
        self.init(
            horizontalSpacing: spacing,
            verticalSpacing: spacing,
            alignment: alignment
        )
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        arrange(maxWidth: proposal.width ?? .infinity, subviews: subviews).size
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let result = arrange(maxWidth: bounds.width, subviews: subviews)

        for (index, frame) in result.frames.enumerated() {
            subviews[index].place(
                at: CGPoint(
                    x: bounds.minX + frame.minX,
                    y: bounds.minY + frame.minY
                ),
                anchor: .topLeading,
                proposal: ProposedViewSize(
                    width: frame.width,
                    height: frame.height
                )
            )
        }
    }

    private struct Row {
        var indices: [Int] = []
        var sizes: [CGSize] = []
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    private struct Arrangement {
        var frames: [CGRect]
        var size: CGSize
    }

    // Single source of truth for row breaking, shared by sizing and placing
    // so both always agree on the result.
    private func arrange(maxWidth: CGFloat, subviews: Subviews) -> Arrangement {
        let hasFiniteWidth = maxWidth.isFinite

        // Children never get more width than the container offers.
        let childProposal = ProposedViewSize(
            width: hasFiniteWidth ? maxWidth : nil,
            height: nil
        )

        var rows: [Row] = []
        var current = Row()

        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(childProposal)
            let neededWidth =
                current.indices.isEmpty
                ? size.width
                : current.width + horizontalSpacing + size.width

            if !current.indices.isEmpty, hasFiniteWidth,
                neededWidth > maxWidth + 0.001
            {
                rows.append(current)
                current = Row()
            }

            current.width =
                current.indices.isEmpty
                ? size.width
                : current.width + horizontalSpacing + size.width
            current.height = max(current.height, size.height)
            current.indices.append(index)
            current.sizes.append(size)
        }
        if !current.indices.isEmpty {
            rows.append(current)
        }

        let widestRow = rows.map(\.width).max() ?? 0
        let containerWidth = hasFiniteWidth ? maxWidth : widestRow

        var frames = Array(repeating: CGRect.zero, count: subviews.count)
        var y: CGFloat = 0

        for row in rows {
            var x: CGFloat
            switch alignment {
            case .leading: x = 0
            case .center: x = (containerWidth - row.width) / 2
            case .trailing: x = containerWidth - row.width
            }

            for (offset, index) in row.indices.enumerated() {
                let size = row.sizes[offset]
                frames[index] = CGRect(origin: CGPoint(x: x, y: y), size: size)
                x += size.width + horizontalSpacing
            }
            y += row.height + verticalSpacing
        }

        let totalHeight = rows.isEmpty ? 0 : y - verticalSpacing

        return Arrangement(
            frames: frames,
            size: CGSize(width: containerWidth, height: totalHeight)
        )
    }
}

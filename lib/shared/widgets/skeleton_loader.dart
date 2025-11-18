import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A widget to create a shimmering skeleton placeholder.
class Skeleton extends StatelessWidget {
  const Skeleton({Key? key, this.height, this.width, this.radius = 12}) : super(key: key);

  final double? height, width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
    );
  }
}

/// A skeleton loader for the InvoiceCard.
class InvoiceCardSkeleton extends StatelessWidget {
  const InvoiceCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                const Skeleton(height: 48, width: 48, radius: 12),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Skeleton(width: 150, height: 18),
                      const SizedBox(height: 8),
                      const Skeleton(width: 100, height: 14),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Amount Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Skeleton(width: 80, height: 12),
                      const SizedBox(height: 8),
                      const Skeleton(width: 120, height: 24),
                    ],
                  ),
                  const Skeleton(width: 80, height: 28, radius: 20),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Due Date
            const Skeleton(width: 150, height: 14),
          ],
        ),
      ),
    );
  }
}

/// A skeleton loader for the ContractCard.
class ContractCardSkeleton extends StatelessWidget {
  const ContractCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Skeleton(width: 120, height: 20),
                const Skeleton(width: 80, height: 28, radius: 20),
              ],
            ),
            const SizedBox(height: 12),
            const Skeleton(width: double.infinity, height: 14),
            const SizedBox(height: 8),
            const Skeleton(width: 180, height: 14),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Skeleton(width: 100, height: 14),
                const Skeleton(width: 100, height: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A skeleton loader for the ChatRoomCard.
class ChatRoomCardSkeleton extends StatelessWidget {
  const ChatRoomCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: <Widget>[
            const Skeleton(height: 56, width: 56, radius: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Skeleton(width: 120, height: 16),
                  const SizedBox(height: 8),
                  const Skeleton(width: double.infinity, height: 14),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Skeleton(width: 50, height: 12),
                const SizedBox(height: 8),
                const Skeleton(height: 24, width: 24, radius: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A skeleton loader for the MaintenanceRequestCard.
class MaintenanceRequestCardSkeleton extends StatelessWidget {
  const MaintenanceRequestCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 2.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Skeleton(height: 48, width: 48, radius: 12),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Skeleton(width: 150, height: 18),
                      const SizedBox(height: 8),
                      const Skeleton(width: 100, height: 14),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Skeleton(width: 90, height: 28, radius: 20),
              ],
            ),
            const SizedBox(height: 16),
            const Skeleton(width: double.infinity, height: 40),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Skeleton(width: 120, height: 14),
                const Skeleton(width: 70, height: 24, radius: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A skeleton loader for the MaintenanceCard.
class MaintenanceCardSkeleton extends StatelessWidget {
  const MaintenanceCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(child: Skeleton(height: 24, width: 200)),
                const SizedBox(width: 8),
                const Skeleton(width: 100, height: 36, radius: 20),
              ],
            ),
            const SizedBox(height: 16),
            const Skeleton(height: 50, width: double.infinity),
            const SizedBox(height: 16),
            const Skeleton(height: 20, width: 220),
            const SizedBox(height: 10),
            const Skeleton(height: 20, width: 180),
            const Divider(height: 28, thickness: 1),
            Row(
              children: [
                Expanded(child: const Skeleton(height: 40)),
                const SizedBox(width: 8),
                Expanded(child: const Skeleton(height: 40)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
